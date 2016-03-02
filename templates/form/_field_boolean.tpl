<div class="form-group row">
    <div class="col-md-{% if small %}3{% else %}9{% endif %} col-md-offset-3">
        <div class="checkbox">
            <label>
                <input type="checkbox" id="{{ #id }}{{ lang_code_for_id }}" name="{{ name }}{{ lang_code_with_dollar }}" 
                    {% if r[name|as_atom]|default:defaultvalue %}checked{% endif %}
                    value="true"
                    {% include "_language_attrs.tpl" language=lang_code class="field-"|append:name %} />
                {{ label }}
            </label>
        </div>
    </div>
</div>
