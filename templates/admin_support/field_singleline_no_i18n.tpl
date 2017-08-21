<div class="form-group row">
  <label class="control-label col-md-3" for="{{ #id }}">{{ label }}</label>
  <div class="col-md-{% if small %}3{% elif medium %}6{% else %}9{% endif %}">
    <input type="{{ type | default:"text" }}" id="{{ #id }}" name="{{ name }}"
      value="{{ r[name|as_atom]|default:defaultvalue }}" class="form-control"
      {% if not is_editable %}disabled="disabled"{% endif %}
      {% if placeholder %}placeholder="{{ placeholder }}"{% endif %} />
    {% if is_required and is_email %}
      {% validate id=#id name=name type={presence} type={email} %}
    {% elif is_required %}
      {% validate id=#id name=name type={presence} %}
    {% endif %}
  </div>
</div>
