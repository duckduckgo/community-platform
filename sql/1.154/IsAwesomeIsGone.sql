update instant_answer set dev_milestone = 'deprecated', blockgroup = null, production_state = 'offline' where perl_module like 'DDG::Goodie::IsAwesome::%';
