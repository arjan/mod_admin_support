{% with #input.name as inputid %}
    <div class="control-group">
        <label for="{{ inputid }}">{{ label }} {% if required %}*{% endif %}</label>
        {% if textarea %}
            <textarea id="{{ inputid }}" ng-model="{{ name }}" class="{{ class }}" {% if required %}required{% endif %}></textarea>
        {% elseif email %}
            <input id="{{ inputid }}" ng-model="{{ name }}" type="email" class="{{ class }}" {% if required %}required{% endif %} {% if disabled %}disabled{% endif %} />
        {% else %}
            <input id="{{ inputid }}" ng-model="{{ name }}" type="text" class="{{ class }}" {% if numeric %}float{% endif %} {% if required %}required{% endif %} {% if disabled %}disabled{% endif %} />
        {% endif %}
        {#
        {% if numeric and required %}
            {% validate id=inputid name=name type={presence}
                type={numericality
                    is_float
                    not_a_number_message="Voer een getal in, gebruik de punt als decimaalscheiding."
                    not_an_integer_message="Voer een getal in, gebruik de punt als decimaalscheiding."
                } %}
        {% elseif required and email %}
            {% validate id=inputid name=name type={presence} type={email} %}
        {% elseif email %}
            {% validate id=inputid name=name type={email} %}
        {% elseif numeric %}
            {% validate id=inputid name=name type={numericality not_a_number_message="Voer een getal in, gebruik de punt als decimaalscheiding."} %}
        {% elseif required %}
            {% validate id=inputid name=name type={presence} %}
        {% endif %}
        #}
        {% if help %}<span class="help">{{ help }}</span>{% endif %}
    </div>
{% endwith %}
