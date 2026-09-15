{# /*============================================================================
  #Instagram (y TikTok)
  El usuario se escribe como en la app (2026-09-15, pedido de Santiago):
  @usuario en la tipografia del sistema operativo, en negrita, con el tilde
  azul de verificada en Instagram. Al lado va TikTok (Santiago, 2026-09-15:
  "no pongas solamente el Instagram"), si esta cargado en el panel
  (store.tiktok). Debajo, el feed de nueve fotos que llena la plataforma
  cuando Instagram esta conectado; sin conexion, solo el aviso.
==============================================================================*/#}

{% if settings.show_instafeed and store.instagram %}
    <section class="section-instafeed-home" data-store="home-instagram-feed">
        <div class="container">
            <div class="row">
                {% set instuser = store.instagram|split('/')|last %}
                <div class="col-12 text-center">
                    <div class="lu-redes-fila">
                        <a target="_blank" rel="noopener" href="{{ store.instagram }}" class="instafeed-title" aria-label="{{ 'Instagram de' | translate }} {{ store.name }}">
                            {% include "snipplets/svg/instagram.tpl" with {svg_custom_class: "icon-inline icon-3x align-top svg-icon-text"} %}
                            <span class="instafeed-user-fila">
                                <h2 class="h2 h1-md mt-2 instafeed-user">{{ instuser }}</h2>
                                {% if settings.lupita_ig_verificada %}
                                    <svg class="instafeed-verificada" viewBox="0 0 40 40" role="img" aria-label="{{ 'Cuenta verificada' | translate }}"><path fill="#0095F6" fill-rule="evenodd" d="M19.998 3.094 14.638 0l-2.972 5.15H5.432v6.354L0 14.64 3.094 20 0 25.359l5.432 3.137v5.905h5.975L14.638 40l5.36-3.094L25.358 40l3.232-5.6h6.162v-6.01L40 25.359 36.905 20 40 14.641l-5.248-3.03v-6.46h-6.419L25.358 0l-5.36 3.094Zm7.415 11.225 2.254 2.287-11.43 11.5-6.835-6.93 2.244-2.258 4.587 4.581 9.18-9.18Z"/></svg>
                                {% endif %}
                            </span>
                        </a>
                        {% if store.tiktok %}
                            {% set tiktokuser = store.tiktok|split('/')|last|trim('@') %}
                            <a target="_blank" rel="noopener" href="{{ store.tiktok }}" class="instafeed-title lu-tiktok-title" aria-label="{{ 'TikTok de' | translate }} {{ store.name }}">
                                {% include "snipplets/svg/tiktok.tpl" with {svg_custom_class: "icon-inline icon-3x align-top svg-icon-text"} %}
                                <span class="instafeed-user-fila">
                                    <span class="h2 h1-md mt-2 instafeed-user">{{ tiktokuser }}</span>
                                </span>
                            </a>
                        {% endif %}
                    </div>
                    <div class="js-ig-fallback text-center mt-3">
                        <div class="mb-3">{{ 'Seguinos en nuestras redes' | translate }}</div>
                        <a target="_blank" rel="noopener" href="{{ store.instagram }}" class="btn btn-link">{{ 'Ver perfil' | translate }}</a>
                    </div>
                </div>
            </div>
        </div>
        {% if store.hasInstagramToken() %}
            <div id="instagram-feed" class="js-ig-success row no-gutters"
                data-ig-feed
                data-ig-items-count="9"
                data-ig-item-class="col-4"
                data-ig-link-class="instafeed-link"
                data-ig-image-class="instafeed-img w-100 fade-in"
                data-ig-aria-label="{{ 'Publicación de Instagram de' | translate }} {{ store.name }}"
                style="display: none;">
            </div>
        {% endif %}
    </section>
{% endif %}
