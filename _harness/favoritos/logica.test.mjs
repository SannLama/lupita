/* Tests de la logica de favoritos. Uso: node --test _harness/favoritos/ */
import { test } from 'node:test'
import assert from 'node:assert/strict'
import {
  CLAVE, MAXIMO, disponible, leer, guardar, contiene, alternar, quitar,
  mensajeWhatsApp, urlWhatsApp,
} from './logica.mjs'

function almacen() {
  const datos = new Map()
  return {
    getItem: (k) => (datos.has(k) ? datos.get(k) : null),
    setItem: (k, v) => { datos.set(k, String(v)) },
    removeItem: (k) => { datos.delete(k) },
  }
}

const vestido = { id: '11', nombre: 'Vestido midi', url: '/vestido', imagen: '/v.jpg', precio: '$ 74.500', variante: '' }
const blazer = { id: '22', nombre: 'Blazer estructurado', url: '/blazer', imagen: '/b.jpg', precio: '$ 145.000', variante: 'Talle S / Crudo' }

test('disponible: true con un almacen que funciona, false si tira', () => {
  assert.equal(disponible(almacen()), true)
  const roto = { setItem() { throw new Error('QuotaExceeded') }, removeItem() {} }
  assert.equal(disponible(roto), false)
  assert.equal(disponible(undefined), false)
})

test('leer: lista vacia si no hay nada, si el JSON esta roto o no es una lista', () => {
  const a = almacen()
  assert.deepEqual(leer(a), [])
  a.setItem(CLAVE, '{roto')
  assert.deepEqual(leer(a), [])
  a.setItem(CLAVE, '{"id":1}')
  assert.deepEqual(leer(a), [])
})

test('leer: descarta entradas sin id', () => {
  const a = almacen()
  a.setItem(CLAVE, JSON.stringify([vestido, { nombre: 'sin id' }]))
  assert.deepEqual(leer(a), [vestido])
})

test('guardar y leer ida y vuelta', () => {
  const a = almacen()
  guardar(a, [vestido, blazer])
  assert.deepEqual(leer(a), [vestido, blazer])
})

test('alternar agrega si no esta y quita si esta', () => {
  let r = alternar([], vestido)
  assert.equal(r.guardada, true)
  assert.deepEqual(r.lista, [vestido])
  assert.equal(contiene(r.lista, '11'), true)
  r = alternar(r.lista, vestido)
  assert.equal(r.guardada, false)
  assert.deepEqual(r.lista, [])
})

test('alternar con otra variante del mismo producto actualiza, no quita ni duplica', () => {
  const conTalle = { ...vestido, variante: 'Talle M / Negro' }
  const r = alternar([vestido], conTalle)
  assert.equal(r.guardada, true)
  assert.equal(r.lista.length, 1)
  assert.equal(r.lista[0].variante, 'Talle M / Negro')
})

test('alternar compara ids como texto', () => {
  const r = alternar([vestido], { ...vestido, id: 11 })
  assert.equal(r.guardada, false)
})

test(`alternar respeta el maximo de ${MAXIMO}: descarta la mas vieja`, () => {
  let lista = []
  for (let i = 0; i < MAXIMO; i++) lista = alternar(lista, { ...vestido, id: String(i) }).lista
  const r = alternar(lista, { ...vestido, id: 'nueva' })
  assert.equal(r.lista.length, MAXIMO)
  assert.equal(contiene(r.lista, '0'), false)
  assert.equal(contiene(r.lista, 'nueva'), true)
})

test('quitar saca por id', () => {
  assert.deepEqual(quitar([vestido, blazer], '11'), [blazer])
})

test('mensajeWhatsApp arma una linea por prenda, con variante si la hay', () => {
  assert.equal(
    mensajeWhatsApp([vestido, blazer]),
    'Hola! Quiero probarme estas prendas en la tienda:\n– Vestido midi\n– Blazer estructurado (Talle S / Crudo)'
  )
})

test('urlWhatsApp agrega el texto con ? o con & segun el link', () => {
  const texto = encodeURIComponent(mensajeWhatsApp([vestido]))
  assert.equal(urlWhatsApp('https://wa.me/5491100000000', [vestido]), `https://wa.me/5491100000000?text=${texto}`)
  assert.equal(urlWhatsApp('https://api.whatsapp.com/send?phone=549110', [vestido]), `https://api.whatsapp.com/send?phone=549110&text=${texto}`)
  assert.equal(urlWhatsApp('', [vestido]), '')
})
