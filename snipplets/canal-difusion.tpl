{# /*============================================================================
  #Canal de difusion (2026-09-15)
  Reemplaza al newsletter del pie (pedido de Santiago): en vez de pedir el
  mail, un link para unirse al canal de difusion de la marca. El canal todavia
  no existe: con "Link al canal de difusión" vacio en el panel, el bloque no se
  muestra. Misma caja que el newsletter (.newsletter), asi hereda su lugar
  encabezando el pie.
==============================================================================*/#}

{% if settings.lupita_canal_url %}
    {# Alineado al margen de la pagina, como las columnas del pie (Santiago, 2026-09-28; antes centrado en col-md-8) #}
    <div class="row">
        <div class="col-12">
            <div class="newsletter section-footer lu-canal">
                <h3>{{ settings.lupita_canal_titulo ? settings.lupita_canal_titulo : 'Unite a nuestro canal' | translate }}</h3>
                {% if settings.lupita_canal_texto %}
                    <p>{{ settings.lupita_canal_texto }}</p>
                {% endif %}
                {# Boton 3D (Santiago, 2026-09-28, referencia "3d button" de 21st.dev): ver #Boton 3D en lupita.scss.tpl. Sobre el pie turquesa va en chocolate. #}
                <a href="{{ settings.lupita_canal_url }}" target="_blank" rel="noopener" class="btn lu-canal-btn lu-3d lu-3d-oscuro"><span class="lu-3d-cara"><span class="js-lu-3d-texto lu-3d-texto">{{ settings.lupita_canal_boton ? settings.lupita_canal_boton : 'Unirme al canal' | translate }}</span><svg class="lu-3d-flecha" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.25" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14"/><path d="m12 5 7 7-7 7"/></svg></span></a>
            </div>
        </div>
    </div>
{% endif %}
