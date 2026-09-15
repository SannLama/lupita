/* Logica pura de favoritos: sin DOM, testeable con node --test.
   Una prenda: { id, nombre, url, imagen, precio, variante }. */

export const CLAVE = 'lupita:favoritos'
export const MAXIMO = 50

/** true si el almacen deja escribir (modo privado o cuota llena → false) */
export function disponible(almacen) {
  if (!almacen) return false
  try {
    const prueba = CLAVE + ':prueba'
    almacen.setItem(prueba, '1')
    almacen.removeItem(prueba)
    return true
  } catch (e) {
    return false
  }
}

export function leer(almacen) {
  try {
    const lista = JSON.parse(almacen.getItem(CLAVE) || '[]')
    return Array.isArray(lista) ? lista.filter((p) => p && p.id != null && p.id !== '') : []
  } catch (e) {
    return []
  }
}

export function guardar(almacen, lista) {
  try {
    almacen.setItem(CLAVE, JSON.stringify(lista))
  } catch (e) {
    /* cuota llena: la lista en memoria sigue valiendo para esta visita */
  }
}

const mismo = (a, b) => String(a) === String(b)

export function contiene(lista, id) {
  return lista.some((p) => mismo(p.id, id))
}

/** Agrega o quita. Si ya esta con otra variante, la actualiza en vez de quitar. */
export function alternar(lista, prenda) {
  const actual = lista.find((p) => mismo(p.id, prenda.id))
  if (actual) {
    if (prenda.variante && prenda.variante !== actual.variante) {
      return { lista: lista.map((p) => (mismo(p.id, prenda.id) ? { ...p, variante: prenda.variante } : p)), guardada: true }
    }
    return { lista: quitar(lista, prenda.id), guardada: false }
  }
  const nueva = [...lista, prenda]
  return { lista: nueva.slice(Math.max(0, nueva.length - MAXIMO)), guardada: true }
}

export function quitar(lista, id) {
  return lista.filter((p) => !mismo(p.id, id))
}

export function mensajeWhatsApp(lista) {
  const lineas = lista.map((p) => `– ${p.nombre}${p.variante ? ` (${p.variante})` : ''}`)
  return ['Hola! Quiero probarme estas prendas en la tienda:', ...lineas].join('\n')
}

/** Suma el mensaje al link de WhatsApp que carga la tienda (wa.me o api.whatsapp.com) */
export function urlWhatsApp(base, lista) {
  if (!base) return ''
  return `${base}${base.includes('?') ? '&' : '?'}text=${encodeURIComponent(mensajeWhatsApp(lista))}`
}
