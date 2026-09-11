<section class="section-advertising">
	<div class="container">
	    <div class="row-fluid">
	        <div class="col text-center">
	           	{% if settings.ad_bar and settings.ad_text %}
	           	    {% set ad_parts = settings.ad_text | split('—') %}
	           	    {% if settings.ad_url %}
				        <a class="link-contrast" href="{{ settings.ad_url | setting_url }}">
					{% endif %}
					{% if ad_parts | length > 1 %}
						{# Varios mensajes separados por "—" en el mismo campo: rotan solos,
						   sin pedirle a la clienta un campo nuevo. Ver la nota en lupita.scss.tpl
						   sobre por que el destino del keyframe es -100% fijo, no (N-1)/N. #}
						<span class="ad-rotator">
							<span class="ad-track" style="animation-duration: {{ ad_parts | length * 4 }}s; animation-timing-function: steps({{ ad_parts | length }});">
								{% for part in ad_parts %}
									<span class="ad-msg">{{ part | trim }}</span>
								{% endfor %}
							</span>
						</span>
					{% else %}
			        	{{ settings.ad_text }}
					{% endif %}
					{% if settings.ad_url %}
				        </a>
			        {% endif %}
			    {% endif %}
	        </div>
	    </div>
	</div>
</section>