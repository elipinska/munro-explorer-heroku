require_relative('../models/hiker')
require_relative('../models/hike')
require_relative('../models/munro')

hiker1 = Hiker.new({'first_name'=> 'Ewa', 'last_name'=>'Lipinska', 'date_of_birth'=>'1990-10-10', 'munro_goal'=>'10'})
hiker1.save()

hiker2 = Hiker.new({'first_name'=> 'Kasia', 'last_name'=>'Agrafka', 'date_of_birth'=>'1988-02-26'})
hiker2.save()

hiker3 = Hiker.new({'first_name'=> 'James', 'last_name'=>'Yates', 'date_of_birth'=>'1989-06-07', 'munro_goal'=>'3'})
hiker3.save()

munro1 = Munro.new({'name'=>'Ben Nevis', 'region'=>'Fort William', 'altitude'=>'1345'})
munro1.save()

munro2 = Munro.new({'name'=>'Ben Lomond', 'region'=>'Loch Lomond', 'altitude'=>'974m'})
munro2.save()

munro3 = Munro.new({'name'=>'A\' Bhuidheanach Bheag', 'region'=>'Cairngorms', 'altitude'=>'936'})
munro3.save()

munro4 = Munro.new({'name'=>'Inaccessible Pinnacle', 'region'=>'Islands', 'altitude'=>'986'})
munro4.save()

hike1 = Hike.new('hiker_id'=>'1', 'munro_id'=>'2', 'date'=>'2017-07-10')
hike1.save()

hike2 = Hike.new('hiker_id'=>'2', 'munro_id'=>'4', 'date'=>'2016-06-15')
hike2.save()

hike3 = Hike.new('hiker_id'=>'3', 'munro_id'=>'1', 'date'=>'2017-10-10')
hike3.save()

hike4 = Hike.new('hiker_id'=>'1', 'munro_id'=>'3', 'date'=>'2016-09-03')
hike4.save()
