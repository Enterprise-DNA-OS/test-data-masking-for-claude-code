INSERT INTO environments(id,name,owner,purpose,retention_due,refreshed_at) VALUES
 ('10000000-0000-4000-8000-000000000001','Partner acceptance','Mira Chen','Partner acceptance rehearsal',current_date+14,now()-interval '4 days'),
 ('10000000-0000-4000-8000-000000000002','Partner training','Theo West','Staff training rehearsal',current_date-2,now()-interval '40 days'),
 ('10000000-0000-4000-8000-000000000003','Release rehearsal','Aroha Bell','Release regression',current_date+30,now()-interval '1 day') ON CONFLICT DO NOTHING;
INSERT INTO field_rules(object_name,field_name,action,domain,reason) VALUES
 ('Account','Id','token','account','Keep synthetic account relationships'),
 ('Account','Name','token','company','Replace business names in test copies'),
 ('Account','BillingCountry','keep','','Country needed for regional test cases'),
 ('Account','Phone','erase','','Calling is outside this test'),
 ('Contact','Id','token','contact','Synthetic contact identity'),
 ('Contact','AccountId','token','account','Keep synthetic account relationships'),
 ('Contact','FirstName','token','person','Replace personal names'),
 ('Contact','LastName','token','person','Replace personal names'),
 ('Contact','Email','email','email','Use reserved invalid email domain'),
 ('Contact','Phone','erase','','Calling is outside this test'),
 ('Contact','Description','erase','','Free text is outside this test') ON CONFLICT DO NOTHING;
INSERT INTO issues(id,name,environment_id,owner,due) VALUES
 ('20000000-0000-4000-8000-000000000001','Confirm training copy disposal','10000000-0000-4000-8000-000000000002','Theo West',current_date-3),
 ('20000000-0000-4000-8000-000000000002','Review regional field justification','10000000-0000-4000-8000-000000000003','Aroha Bell',current_date+2) ON CONFLICT DO NOTHING;
