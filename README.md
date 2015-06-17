## Rails Example Application

### Problem

Cannot use localization to rename a nested, polymorphic attributes
when used in errors for the parent model.

#### Example

* User model
* Address model, polymorphic
* Employer model

* User has one Mailing Address, polymorphic Address
* User has one Employer

* User validates `username`, `email`, `mailing_address`, and
`employer` for `presence`.

* Address validates `street`, `locality`, `region`, `country` and
`postal_code`.

* Employer validates `name`.

### Methodology

Setting new names for attributes in the config/locales/en.yml file as:

``` yaml
en:
  activerecord:
    attributes:
      address:
        locality: "City"
        region: "State"
      employer:
        name: "Nom"
      user:
        address.locality: "City"
        address.region: "State"
        mailing_address.locality: "City"
        mailing_address.region: "State"
        employer.name: "Societe Nom"
```

Building a new, unsaved user with new mailing address and new employer
(i.e., all fields are empty, which will not validate).

`u.errors.full_messages` will use the translations for the nested
employer, but **NOT** for the nested, polymorphic mailing address.

```
$ rails c
Loading development environment (Rails 4.2.1)
[1] pry(main)> user = User.new(mailing_address: Address.new, employer: Employer.new)
=> #<User:0x007f81e28ab4f0 id: nil, username: nil, lastname: nil, firstname: nil, email: nil, created_at: nil, updated_at: nil>
[2] pry(main)> user.valid?
=> false
[3] pry(main)> user.errors
=> #<ActiveModel::Errors:0x007f81e2951710
 @base=#<User:0x007f81e28ab4f0 id: nil, username: nil, lastname: nil, firstname: nil, email: nil, created_at: nil, updated_at: nil>,
 @messages=
  {:"employer.name"=>["can't be blank"],
   :"mailing_address.street"=>["can't be blank"],
   :"mailing_address.locality"=>["can't be blank"],
   :"mailing_address.region"=>["can't be blank"],
   :"mailing_address.country"=>["can't be blank"],
   :"mailing_address.postal_code"=>["can't be blank"],
   :username=>["can't be blank"],
   :email=>["can't be blank"]}>
[4] pry(main)> user.errors.full_messages
=> ["Nom can't be blank",
 "Mailing address street can't be blank",
 "Mailing address locality can't be blank",
 "Mailing address region can't be blank",
 "Mailing address country can't be blank",
 "Mailing address postal code can't be blank",
 "Username can't be blank",
 "Email can't be blank"]
 ```

You can see that `employer.name` in the errors collection was turned
into "Nom" in the full messages, while `mailing_address.locality` was
**NOT** turned into "City", nor `mailing_address.region` was **NOT**
turned into "State".

### Conclusion

What is the magic that will make a nested polymorphic table work like
a regular nested table?

### Links

* <http://guides.rubyonrails.org/i18n.html#translations-for-active-record-models>
shows how to set up ActiveRecord attribute translations, and discusses
how to use them, but does not say anything about using them in
ActiveModel::Errors. For non-polymorphic error messages, they work
just fine. For the polymorphic error messages, however, they do not.

* <http://stackoverflow.com/questions/23714849/translation-for-nested-attributes-in-polymorphic-relationship>
also discusses how to use them in helpers and forms, but does not
touch on the error messages.
