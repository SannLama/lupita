{# /*============================================================================
  #Canal de difusion (2026-09-15)
  Reemplaza al newsletter del pie (pedido de Santiago): en vez de pedir el
  mail, un link para unirse al canal de difusion de la marca. El canal todavia
  no existe: con "Link al canal de difusión" vacio en el panel, el bloque no se
  muestra. Misma caja que el newsletter (.newsletter), asi hereda su lugar
  encabezando el pie.
==============================================================================*/#}

{% if settings.lupita_canal_url %}
    <div class="row justify-content-md-center">
        <div class="col-md-8 text-center">
            <div class="newsletter section-footer lu-canal">
                <h3>{{ settings.lupita_canal_titulo ? settings.lupita_canal_titulo : 'Unite a nuestro canal' | translate }}</h3>
                {% if settings.lupita_canal_texto %}
                    <p>{{ settings.lupita_canal_texto }}</p>
                {% endif %}
                <a href="{{ settings.lupita_canal_url }}" target="_blank" rel="noopener" class="btn lu-canal-btn">{{ settings.lupita_canal_boton ? settings.lupita_canal_boton : 'Unirme al canal' | translate }}</a>
            </div>
        </div>
    </div>
{% endif %}
