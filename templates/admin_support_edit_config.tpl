{% extends "admin.tpl" %}

{% block title %}{{ title }}{% endblock %}

{% block content %}

    <h2>{{ title }}</h2>
    <hr />

    <div class="row">
        {% wire id=#form type="submit" delegate=`mod_admin_support` postback={edit_config_save module=module fields=fields} %}
        <form id="{{ #form }}" class="form-horizontal col-lg-6" method="post" action="postback">
            {% for key, label in fields %}

                    <div class="form-group row">
                        <label class="control-label col-md-3" for="{{ #title }}{{ lang_code_for_id }}">{{ label }}</label>
                        <div class="col-md-9">
                            <textarea class="form-control" rows=6 id=#foo.key name="{{ key }}">{{ m.config[module][key].value|default:"Foo" }}</textarea>
                            {% validate id=#foo.key presence %}
                        </div>
                    </div>

            {% endfor %}

            <button class="btn btn-primary">{_ Save _}</button>
            
        </form>

    </div>
    
    {% debug %}
    
{% endblock %}
