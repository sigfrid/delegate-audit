# delegate-audit

Audit AR models with a delegator object - POC


## Usage
`rake console`


## API
```
r = Role.new(name: 'user')
r.association(:activities).send(:build_through_record, Activity.first)
r.association(:users).send(:build_through_record, User.first)
a = Audited.new(r)
a.save!
r.name = "super-user"
r.duties.detect { |d| d.activity_id == 1 }.activity_id = nil
r.association(:activities).send(:build_through_record, Activity.last)
r.association(:users).send(:build_through_record, User.last)
a.save!
```


```
r = Role.new(name: 'user')
r.association(:activities).send(:build_through_record, Activity.first)
r.association(:activities).send(:build_through_record, Activity.last)
r.association(:users).send(:build_through_record, User.first)
a = Audited.new(r)
a.save!
```
