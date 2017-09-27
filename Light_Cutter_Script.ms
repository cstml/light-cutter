rollout lights_rol "Lights"
(
	global lightarray = #()
	global xno = 4
	global yno = 4
	global space = 50 
	global height = 250
	global percent1 = 50
	global r = 180
	global g = 180
	global b = 180
	global hotspot = 43.0
	global field = 45.0
	global lightvalue = 180
	global multiplier = 1.0
	global lightforinspection = targetspot
	
	fn generatelights = -- a function to generate an array of spotlights 
	(
		lightarray = #()
		for i = 1 to xno do
		(
			for j = 1 to yno do
			(
				t = targetobject pos:[(i+(i*space)),(j+(j*space)),0]
				l = targetspot pos:[(i+(i*space)),(j+(j*space)),height] target: t
				append lightarray t -- has to be in terms of targets not spotlights in order to keep the spotlights in a fixed state and tethered to their targets 
			)
		)
	)
	
	fn turnoff = -- a function to turn selected lights off
	(
		for targetspot in selection do 
		targetspot.enabled = false
	)
	
	fn turnon = -- a function to turn selected lights on 
	(
		for targetspot in selection do
		targetspot.enabled = true
	)
	
	fn turnonall = -- a function to turn all lights in the scene on
	(
		for targetspot in lights do
		targetspot.enabled = true
	)
	
	fn turnoffall = -- a function to turn all lights in the scene off
	(
		for targetspot in lights do
		targetspot.enabled = false
	)
	
	fn selectpercentage1 = --select a random collection of lights from a percentage --modified from http://docs.autodesk.com/3DSMAX/16/ENU/MAXScript-Help//index.html?query=0 which deletes a random selection of objects
	(
		candidates = for l in lights where classof l != targetobject collect l --define which objects can be collected 
		selectedobjects = #() --empty array of objects to be selected 
		numbertoselect = (percent1 / 100.0 * candidates.count) as integer --calculating number to select
		while selectedobjects.count < numbertoselect do
		( 
			newindex = random 1 candidates.count
			if finditem selectedobjects candidates[newindex] == 0 do
				append selectedobjects candidates[newindex]
		)
		select selectedobjects
	)
		
	fn changecolor = -- a function to change the color of selected lights
	(
		for targetspot in selection do
		targetspot.rgb = (color r g b)
	)
	
	fn changehotspot = -- a function to change the hotspot of selected lights 
	(
		for targetspot in selection do
		targetspot.hotspot = hotspot
	)
	
	fn changefalloff = -- a function to change the falloff of selected lights
	(
		for targetspot in selection do 
		targetspot.falloff = field
	)
	
	fn changevalue = -- a function to change the value of selected lights
	(
		for targetspot in selection do 
		targetspot.value = lightvalue
	)
	
	fn changemultiplier = -- a function to change the multiplier of selected lights
	(
		for targetspot in selection do
		targetspot.multiplier = multiplier
	)
	
	group "Generate Lights"
	(
		spinner xno_sp "Number of Lights X-Axis" type:#integer range:[1,20,xno]
		spinner yno_sp "Number of Lights Y-Axis" type:#integer range:[1,20,yno]
		spinner space_sp "Lights Spacing" type:#float range:[50,500,space]
		spinner height_sp "Height" type:#float range:[250,500,height]
		button generate_btn "Generate"
	)
	
	on xno_sp changed amt do xno = amt
	on yno_sp changed amt do yno = amt
	on space_sp changed amt do space = amt
	on height_sp changed amt do height = amt 
	on generate_btn pressed do 
	(
		delete lights --remove existing lights from the scene
		generatelights()
	)
	
	group "Light Selection"
	(
		button selectall1_btn "Select All"
		spinner precent1_sp "Percentage" type:#float range:[0.0,100.0,percent1]
		button selectpercent1_btn "Random Selection By Percentage" 
	)
	
	on selectall1_btn pressed do select (for l in lights where classof l != targetobject collect l)
	on percent1_sp changed amt do percent = amt
	on selectpercent1_btn pressed do selectpercentage1()
	
	group "On and Off"
	(
		button on_btn "Turn Selection On"
		button off_btn "Turn Selection Off"
		button allon_btn "Turn All On"
		button alloff_btn "Turn All Off"
	)
	
	on on_btn pressed do turnon()
	on off_btn pressed do turnoff()
	on allon_btn pressed do turnonall()
	on alloff_btn pressed do turnoffall()
	
	group "Variables"
	(
		spinner red_sp "Red" type:#integer range:[0,360,r]
		spinner green_sp "Green" type:#integer range:[0,360,g]
		spinner blue_sp "Blue" type:#integer range:[0,360,b]
		button updatecolor_btn "Update Colour"
		spinner hotspot_sp "Hotspot" type:#float range:[0,100,hotspot]
		spinner falloff_sp "Falloff" type:#float range:[0,100,field]
		spinner value_sp "Value" type:#integer range:[0,255,lightvalue]
		spinner multiplier_sp "Multiplier" type:#float range:[1.0,5.0,multiplier]
	)
	
	on red_sp changed amt do r = amt
	on green_sp changed amt do g = amt
	on blue_sp changed amt do b = amt
	on updatecolor_btn pressed do changecolor()
	on hotspot_sp changed amt do
	(
		hotspot = amt
		changehotspot()
	)
	on falloff_sp changed amt do
	(
		field = amt
		changefalloff()
	)
	on value_sp changed amt do
	(
		lightvalue = amt
		changevalue()
	)
	on multiplier_sp changed amt do
	(
		multiplier = amt
		changemultiplier()
	)
	
	fn light_filt obj = classof obj == targetspot --filter to ensure only spotlights can be inspected
	
	group "Inspect Variables" --group to check which settings have been input for a light
	(
		pickbutton pickforinspection_btn "Pick Light For Inspection" filter:light_filt
		edittext lightname_tf "Light Selected:" text:"No Light Selected" readonly:true
		edittext lightcolor_tf "Colour:" readonly:true
		edittext hotspot_tf "Hotspot:" readonly:true
		edittext falloff_tf "Falloff:" readonly:true
		edittext value_tf "Value:" readonly:true
		edittext multiplier_tf "Multiplier:" readonly:true
	)
	
	on pickforinspection_btn picked obj do 
	(
		lightforinspection = obj 
		lightname_tf.text = lightforinspection.name
		lightcolor_tf.text = lightforinspection.rgb as string
		hotspot_tf.text = lightforinspection.hotspot as string
		falloff_tf.text = lightforinspection.falloff as string
		value_tf.text = lightforinspection.value as string
		multiplier_tf.text = lightforinspection.multiplier as string
	)
	
)
createdialog lights_rol height:750 width:300 pos:[50,50] 

rollout simulate_rol "Simulate"
(
	global thespline = splineshape
	global thetarget = targetobject
	global therandomtarget = targetobject
	global thepath = shape
	global percent2 = 50
	global x = 0.0
	global y = 0.0
	global z = 0.0
	global t1 = 25
	global t2 = 50
	global t3 = 75
	global p0 = 0
	global p1 = 25
	global p2 = 50
	global p3 = 75
	global p4 = 100
	
	fn selectpercentage2 = 
	(
		candidates = for l in lights where classof l != targetspot collect l 
		selectedobjects = #() 
		numbertoselect = (percent2 / 100.0 * candidates.count) as integer 
		while selectedobjects.count < numbertoselect do
		( 
			newindex = random 1 candidates.count
			if finditem selectedobjects candidates[newindex] == 0 do
				append selectedobjects candidates[newindex]
		)
		select selectedobjects
	)
	
	fn changeposition =
	(
		objectstomove = for l in selection where classof l == targetobject collect l --ensuring only the targets can be moved and not actual lights
		objectstomove.pos = [x,y,z]
	)
	
	fn randomselect = --function to select a single, random target
	( 
		(
			candidates = for l in lights where classof l != targetspot collect l
			( 
				newindex = random 1 candidates.count
				therandomtarget = candidates[newindex]
				select candidates[newindex]
			)
		)
	)
	
	fn randomsmoothspline = -- a function to generate a random curved spline
	(
		local sp = splineshape()
		addnewspline sp
		for i = 1 to (random 2 10) do -- numbers ensure that the line cannot have only a single point and cause an error
		(
			addknot sp 1 #smooth #curve [(random 0 300),(random 0 300),0]
		)
		updateShape sp
		thespline = sp
	)
	
	fn randomsharpspline= -- a function to generate a random spline with corners
	(
		local sp = splineshape()
		addnewspline sp
		for i = 1 to (random 2 10) do
		(
			addknot sp 1 #corner #line [(random 0 300),(random 0 300),0]
		)
		updateShape sp
		thespline = sp
	)
	
	fn randomshape = --a function to generate a random shape to act as a path
	(
		thenumber = (random 0 7)
		if thenumber == 0 then thepath = arc radius:(random 0.1 100) from:(random 0 500) to:(random 0 500) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 1 then thepath = circle radius:(random 0.1 100) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 2 then thepath = rectangle length:(random 0.1 100) width:(random 0.1 100) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 3 then thepath = star radius1:(random 0.1 100) radius2:(random 0.1 100) points:(random 0 10) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 4 then thepath = ellipse length:(random 0.1 100) width:(random 0.1 100) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 5 then thepath = ngon radius:(random 0.1 100) nsides:(random 3 10) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 6 then thepath = helix radius1:(random 0.1 100) radius2:(random 0.1 100) height:0.0 turns:(random 2.0 10.0) bias:(random -1.0 1.0) pos:[(random 0 300),(random 0 300),0] render_renderable:false
		if thenumber == 7 then thepath = egg egg_length:(random 0.1 100) egg_width:(random 0.1 100) egg_angle:(random 0.0 360.0) pos:[(random 0 300),(random 0 300),0] render_renderable:false
	)
	
	fn path_filt obj = classof obj == shape --function to filter paths-- shapes?

	fn target_filt obj = classof obj == targetobject --function to filter targets

	fn linkpathandtarget = --function to set a spotlight to follow a path and then turn animation on, setting keyframes
	(
		thepat = thepath --not sure why these are necessary but wont work without it
		thetarg = thetarget 
		thetarg.pos.controller = path follow:true
		poscont = thetarg.pos.controller
		poscont.path = thepat
		poscont.axis = 2
		animate on
		(
			at time 0 poscont.percent = p0
			at time t1 poscont.percent = p1
			at time t2 poscont.percent = p2
			at time t3 poscont.percent = p3
			at time 100 poscont.percent = p4
		)
	)
	
	group "Target Selection"
	(
		button selectall2_btn "Select All"
		spinner percent2_sp "Percentage" type:#float range:[0.0,100.0,percent2]
		button selectpercent2_btn "Random Selection By Percentage" 
		spinner xpos_sp "X Position" type:#float range:[-1000,1000,x]
		spinner ypos_sp "Y Position" type:#float range:[-1000,1000,y]
		spinner zpos_sp "Z Position" type:#float range:[-1000,1000,z]
		button updatepos_btn "Update Position Of Selection"
	)
	
	on selectall2_btn pressed do select (for l in lights where classof l != targetspot collect l)
	on percent2_sp changed amt do percent2 = amt
	on selectpercent2_btn pressed do selectpercentage2()
	on xpos_sp changed amt do x = amt
	on ypos_sp changed amt do y = amt
	on zpos_sp changed amt do z = amt
	on updatepos_btn pressed do changeposition()
	
	group "Simulate"
	(
		pickbutton path_btn "Choose Path" 
		button randomsmoothspline_btn "Generate Random Smooth Spline"		
		button randomsharpspline_btn "Generate Random Sharp Spline"
		button randomshape_btn "Generate Random Shape"
		edittext pathselection_tf "Path Selected:" text:"No Path Selected" readonly:true
		pickbutton target_btn "Choose Target" filter:target_filt
		button randomselect_btn "Choose Random Target"
		edittext targetselection_tf "Target Selected:" text:"No Target selected" readonly:true
		spinner t1_sp "Time 1" type:#integer range:[0,100,t1]
		spinner t2_sp "Time 2" type:#integer range:[0,100,t2]
		spinner t3_sp "Time 3" type:#integer range:[0,100,t3]
		spinner p0_sp "% Along Path At Start" type:#integer range:[0,100,p0]
		spinner p1_sp "% Along Path At Time 1" type:#integer range:[0,100,p1]
		spinner p2_sp "% Along Path At Time 2" type:#integer range:[0,100,p2]
		spinner p3_sp "% Along Path At Time 3" type:#integer range:[0,100,p3]
		spinner p4_sp "% Along Path At End" type:#integer range:[0,100,p4]
		button linkpathandtarget_btn "Link Path and Target"
		button play_btn "Play Animation"
		button stop_btn "Stop Animation"
	)
	
	on path_btn picked obj do
	(
		thepath = obj
		pathselection_tf.text = thepath.name
	)
	
	on randomsmoothspline_btn pressed do
	(
		randomsmoothspline()
		pathselection_tf.text = thespline.name
		thepath = thespline
	)
	
	on randomsharpspline_btn pressed do
	(
		randomsharpspline()
		pathselection_tf.text = thespline.name
		thepath = thespline
	)
	
	on randomshape_btn pressed do 
	(
		randomshape()
		pathselection_tf.text = thepath.name
	)
	
	on target_btn picked obj do
	(
		thetarget = obj
		targetselection_tf.text = thetarget.name
	)
	
	on randomselect_btn pressed do
	(
		randomselect()
		targetselection_tf.text = therandomtarget.name
		thetarget = therandomtarget
	)
	
	on t1_sp changed amt do t1 = amt
	on t2_sp changed amt do t2 = amt
	on t3_sp changed amt do t3 = amt
	on p0_sp changed amt do p0 = amt
	on p1_sp changed amt do p1 = amt
	on p2_sp changed amt do p2 = amt
	on p3_sp changed amt do p3 = amt
	on p4_sp changed amt do p4 = amt
	
	on linkpathandtarget_btn pressed do
	(
		linkpathandtarget()
	)
	
	on play_btn pressed do playanimation()
	on stop_btn pressed do stopanimation()
	
)
createdialog simulate_rol height:665 width:300 pos:[370,50] 