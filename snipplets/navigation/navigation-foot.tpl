<ul class="footer-menu m-0 p-0">
	{% for item in menus[settings.footer_menu] if item.name | lower not in ['envíos', 'envios'] %}
		<li class="footer-menu-item my-4">
	        <a class="footer-menu-link" href="{{ item.url }}" {% if item.url | is_external %}target="_blank"{% endif %}>{{ item.name }}</a>
		</li>
	{% endfor %}
</ul>