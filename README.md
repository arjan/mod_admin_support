# mod_admin_support
Support routines for quickly building admin interfaces and JSON APIs


## Template helpers



## Easy config pages

Create an edit page for a set of config fields from a module. 

The following dispatch creates an edit page in the admin at the URL `/admin/email-config`, which edits the `mod_example.email_text` config property:

    {admin_verloning_edit_email_config, ["admin", "email-config"],
     controller_template, [{template, "admin_support_edit_config.tpl"},
                           {title, "E-mail texts"},
                           {module, mod_example},
                           {fields, [
                                     {email_text, "E-mail text"}
                                    ]}
                          ]}

Note, currently each field is rendered as a textarea.
