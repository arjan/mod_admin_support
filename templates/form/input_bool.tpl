{% with inputid|default:#input.name as inputid %}
    <div class="control-group">
        <label>{{ label }} {% if required %}*{% endif %}</label>
        <div class="bool">
            <label>
                <input type="checkbox" id="{{ inputid }}" ng-model="{{ name }}" value="true" />
                Ja
            </label>
        </div>
    </div>
{% endwith %}
