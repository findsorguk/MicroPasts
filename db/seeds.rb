# coding: utf-8

puts 'Seeding the database...'

[
  { pt: 'Arte', en: 'Art' },
  { pt: 'Artes plásticas', en: 'Visual Arts' },
  { pt: 'Circo', en: 'Circus' },
  { pt: 'Comunidade', en: 'Community' },
  { pt: 'Humor', en: 'Humor' },
  { pt: 'Quadrinhos', en: 'Comicbooks' },
  { pt: 'Dança', en: 'Dance' },
  { pt: 'Design', en: 'Design' },
  { pt: 'Eventos', en: 'Events' },
  { pt: 'Moda', en: 'Fashion' },
  { pt: 'Gastronomia', en: 'Gastronomy' },
  { pt: 'Cinema e Vídeo', en: 'Film & Video' },
  { pt: 'Jogos', en: 'Games' },
  { pt: 'Jornalismo', en: 'Journalism' },
  { pt: 'Música', en: 'Music' },
  { pt: 'Fotografia', en: 'Photography' },
  { pt: 'Ciência e Tecnologia', en: 'Science & Technology' },
  { pt: 'Teatro', en: 'Theatre' },
  { pt: 'Esporte', en: 'Sport' },
  { pt: 'Web', en: 'Web' },
  { pt: 'Carnaval', en: 'Carnival' },
  { pt: 'Arquitetura e Urbanismo', en: 'Architecture & Urbanism' },
  { pt: 'Literatura', en: 'Literature' },
  { pt: 'Mobilidade e Transporte', en: 'Mobility & Transportation' },
  { pt: 'Meio Ambiente', en: 'Environment' },
  { pt: 'Negócios Sociais', en: 'Social Business' },
  { pt: 'Educação', en: 'Education' },
  { pt: 'Filmes de Ficção', en: 'Fiction Films' },
  { pt: 'Filmes Documentários', en: 'Documentary Films' },
  { pt: 'Filmes Universitários', en: 'Experimental Films' }
].each do |name|
   category = Category.find_or_initialize_by(name_pt: name[:pt])
   category.update_attributes({
     name_en: name[:en]
   })
 end


[
  'confirm_backer','payment_slip','project_success','backer_project_successful',
  'backer_project_unsuccessful','project_received', 'project_received_channel', 'updates','project_unsuccessful',
  'project_visible','processing_payment','new_draft_project', 'new_draft_channel', 'project_rejected',
  'pending_backer_project_unsuccessful', 'project_owner_backer_confirmed', 'adm_project_deadline',
  'project_in_wainting_funds', 'credits_warning', 'backer_confirmed_after_project_was_closed',
  'backer_canceled_after_confirmed', 'new_user_registration', 'new_project_visible'
].each do |name|
#  NotificationType.find_or_create_by(name: name)
end

{
  company_name: 'Micropasts',
  company_logo: 'http://catarse.me/assets/catarse_bootstrap/logo_icon_catarse.png',
  host: 'crowdfunded.micropasts.org',
  base_url: "http://crowdfunded.micropasts.org",
  email_contact: 'info@micropasts.org',
  email_payments: 'funding@micropasts.org',
  email_projects: 'projects@micropasts.org',
  email_system: 'info@micropasts.org',
  email_no_reply: 'no-reply@micropasts.org',
  facebook_url: "http://facebook.com/micropasts",
  facebook_app_id: 'change_me',
  twitter_url: 'http://twitter.com/micropasts',
  twitter_username: "micropasts",
  twitter_widget_id: '407920344578531329',
# mailchimp_url: "http://catarse.us5.list-manage.com/subscribe/post?u=ebfcd0d16dbb0001a0bea3639&amp;id=149c39709e",
  catarse_fee: '0.01',
  support_forum: 'http://community.micropasts.org/',
  base_domain: 'crowdfunded.micropasts.org',
# uservoice_secret_gadget: 'change_this',
# uservoice_key: 'uservoice_key',
  faq_url: 'http://micropasts.org/faq',
  feedback_url: 'http://community.micropasts.org',
  terms_url: 'http://micropasts.org/terms',
  privacy_url: 'http://micropasts.org/privacy',
  about_channel_url: 'http://micropasts/about',
# instagram_url: 'http://instagram.com/catarse_',
  blog_url: "http://micropasts.org",
  github_url: 'http://github.com/findsorguk',
  contato_url: 'http://micropasts.org/contact-us/'
}.each do |name, value|
   conf = Configuration.find_or_initialize_by(name: name)
   conf.update_attributes({
     value: value
   }) if conf.new_record?
end


Channel.find_or_create_by!(name: "Channel name") do |c|
  c.permalink = "sample-permalink"
  c.description = "Lorem Ipsum"
end


OauthProvider.find_or_create_by!(name: 'facebook') do |o|
  o.key = 'your_facebook_app_key'
  o.secret = 'your_facebook_app_secret'
  o.path = 'facebook'
end

OauthProvider.find_or_create_by!(name: 'twitter') do |o|
  o.key = 'your_twitter_app_key'
  o.secret = 'your_twitter_app_secret'
  o.path = 'twitter'
end

OauthProvider.find_or_create_by!(name: 'google_oauth2') do |o|
  o.key = 'your_google_oauth2_app_key'
  o.secret = 'your_google_oauth2_app_secret'
  o.path = 'google_oauth2'
end

OauthProvider.find_or_create_by!(name: 'linkedin') do |o|
  o.key = 'your_linkedin_app_key'
  o.secret = 'your_linkedin_app_secret'
  o.path = 'linkedin'
end

puts
puts '============================================='
puts ' Showing all Authentication Providers'
puts '---------------------------------------------'

OauthProvider.all.each do |conf|
  a = conf.attributes
  puts "  name #{a['name']}"
  puts "     key: #{a['key']}"
  puts "     secret: #{a['secret']}"
  puts "     path: #{a['path']}"
  puts
end


puts
puts '============================================='
puts ' Showing all entries in Configuration Table...'
puts '---------------------------------------------'

Configuration.all.each do |conf|
  a = conf.attributes
  puts "  #{a['name']}: #{a['value']}"
end

puts '---------------------------------------------'
puts 'Done!'
