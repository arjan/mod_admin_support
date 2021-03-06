<div class="form-group row">
    <label class="control-label col-md-3" for="{{ #id }}{{ lang_code_for_id }}">{{ label }} {{ lang_code_with_brackets }}</label>
    <div class="col-md-{% if small %}3{% elif medium %}6{% else %}9{% endif %}">
        <input type="{{ type | default:"text" }}" id="{{ #id }}{{ lang_code_for_id }}" name="{{ name }}{{ lang_code_with_dollar }}"
            value="{{ r[name|as_atom]|default:defaultvalue }}"
            {% if not is_editable %}disabled="disabled"{% endif %}
            {% if placeholder %}placeholder="{{ placeholder }}"{% endif %}
            {% include "_language_attrs.tpl" language=lang_code class="form-control field-"|append:name|append:(autofocus|if:" do_autofocus":"") %} />
        {% if is_required and is_email %}
            {% validate id=#id name=name type={presence} type={email} %}
        {% elif is_required %}
            {% validate id=#id name=name type={presence} %}
        {% endif %}
    </div>
</div>
