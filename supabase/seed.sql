-- Non-user seed data safe to run before real users exist.
insert into public.subscription_plans (code,name,audience,price_minor,currency,billing_interval,entitlements,active) values
('professional-free','Professional Free','individual',0,'INR','month','{"feed":true,"jobs":true,"groups":true,"learning_catalog":true}'::jsonb,true),
('professional-premium','Professional Premium','individual',49900,'INR','month','{"profile_boost":true,"ai_career":true,"branding_tools":true,"premium_learning_discount":true}'::jsonb,true),
('recruiter-pro','Recruiter Pro','company',1499000,'INR','month','{"job_posts":10,"talent_search":true,"candidate_contact":true,"analytics":true}'::jsonb,true),
('corporate','Corporate Membership','company',4999000,'INR','month','{"job_posts":50,"academy_seats":100,"events":true,"talent_search":true,"analytics":true}'::jsonb,true)
on conflict (code) do nothing;

insert into public.groups (name,slug,description,visibility,category) values
('Tanker Professionals','tanker-professionals','Operational, vetting and safety conversations for tanker professionals.','public','Tanker'),
('Marine Engineers Community','marine-engineers','Reliability, troubleshooting, energy efficiency and technical careers.','public','Engineering'),
('Masters & Senior Officers','masters-senior-officers','Leadership, command, navigation, regulation and shore transition.','public','Deck'),
('Women in Maritime','women-in-maritime','Career growth, leadership, mentoring and industry inclusion.','public','Professional'),
('Shore Career Transition','shore-career-transition','Role discovery, CV positioning, interviews, networking and referrals.','public','Career'),
('Maritime Technology','maritime-technology','AI, digitalisation, cyber, data and future-of-shipping discussions.','public','Technology')
on conflict (slug) do nothing;

insert into public.courses (title,slug,category,level,description,price_minor,currency,status) values
('SIRE 2.0: From Procedure to Evidence','sire-2-procedure-to-evidence','Technical','Advanced','Practical officer-focused training on question intent, evidence, human factors and inspection readiness.',149900,'INR','published'),
('TMSA for Senior Officers & Shore Teams','tmsa-senior-officers','Technical','Intermediate','TMSA elements through practical fleet examples and improvement actions.',129900,'INR','published'),
('Shore Transition Blueprint','shore-transition-blueprint','Career Development','All levels','Translate sea-going experience into shore-role positioning, networking and interview outcomes.',99900,'INR','published'),
('AI in Shipping for Maritime Professionals','ai-in-shipping','Future Skills','Beginner','Practical AI use cases in operations, safety, training, maintenance and decision support.',79900,'INR','published')
on conflict (slug) do nothing;
