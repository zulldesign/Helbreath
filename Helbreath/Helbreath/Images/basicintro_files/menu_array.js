//The following line is critical for menu operation, and MUST APPEAR ONLY ONCE. If you have more than one menu_array.js file rem out this line in subsequent files
menunum=0;menus=new Array();_d=document;function addmenu(){menunum++;menus[menunum]=menu;}function dumpmenus(){mt="<script language=javascript>";for(a=1;a<menus.length;a++){mt+=" menu"+a+"=menus["+a+"];"}mt+="<\/script>";_d.write(mt)}
//Please leave the above line intact. The above also needs to be enabled if it not already enabled unless this file is part of a multi pack.


////////////////////////////////////
// Editable properties START here //
////////////////////////////////////

effect = "Fade(duration=0.2);Alpha(style=0,opacity=99);Shadow(color='#78836d', Direction=135, Strength=5)"

timegap=500			// The time delay for menus to remain visible
followspeed=5		// Follow Scrolling speed
followrate=40		// Follow Scrolling Rate
suboffset_top=10;	// Sub menu offset Top position 
suboffset_left=10;	// Sub menu offset Left position
closeOnClick = true

style1=[			// style1 is an array of properties. You can have as many property arrays as you need. This means that menus can have their own style.
"EDE5D8",		    // Mouse Off Font Color
"6B775F",			// Mouse Off Background Color
"F5D12B",			// Mouse On Font Color
"6B775F",			// Mouse On Background Color
"5DC275",			// Menu Border Color 
10,					// Font Size in pixels
"normal",			// Font Style (italic or normal)
"bold",				// Font Weight (bold or normal)
"Verdana, Arial",	// Font Name
4,					// Menu Item Padding
,		            // Sub Menu Image (Leave this blank if not needed)
,					// 3D Border & Separator bar
"66ffff",			// 3D High Color
"000099",			// 3D Low Color
"F5D12B",			// Current Page Item Font Color (leave this blank to disable)
"6B775F",			// Current Page Item Background Color (leave this blank to disable)
,		            // Top Bar image (Leave this blank to disable)
"ffffff",			// Menu Header Font Color (Leave blank if headers are not needed)
"ffffff",			// Menu Header Background Color (Leave blank if headers are not needed)
"CCCCCC",			// Menu Item Separator Color
]


addmenu(menu=[		// This is the array that contains your menu properties and details
"mainmenu",			// Menu Name - This is needed in order for the menu to be called
125,					// Menu Top - The Top position of the menu in pixels
0,				    // Menu Left - The Left position of the menu in pixels
99,				    // Menu Width - Menus width in pixels
0,					// Menu Border Width 
"center",			// Screen Position - here you can use "center;left;right;middle;top;bottom" or a combination of "center:middle"
style1,				// Properties Array - this is set higher up, as above
1,					// Always Visible - allows the menu item to be visible at all time (1=on/0=off)
"center",			// Alignment - sets the menu elements text alignment, values valid here are: left, right or center
,				    // Filter - Text variable for setting transitional effects on menu activation - see above for more info
,					// Follow Scrolling - Tells the menu item to follow the user down the screen (visible at all times) (1=on/0=off)
1, 					// Horizontal Menu - Tells the menu to become horizontal instead of top to bottom style (1=on/0=off)
,					// Keep Alive - Keeps the menu visible until the user moves over another menu or clicks elsewhere on the page (1=on/0=off)
,					// Position of TOP sub image left:center:right
,					// Set the Overall Width of Horizontal Menu to 100% and height to the specified amount (Leave blank to disable)
,					// Right To Left - Used in Hebrew for example. (1=on/0=off)
,					// Open the Menus OnClick - leave blank for OnMouseover (1=on/0=off)
,					// ID of the div you want to hide on MouseOver (useful for hiding form elements)
,					// Background image for menu when BGColor set to transparent.
,					// Scrollable Menu
,					// Reserved for future use
,"Home","index.html",,"Helbreath USA Home",1 // "Description Text", "URL", "Alternate URL", "Status", "Separator Bar"
,"About","show-menu=about","/storyline.htm","",1
,"Downloads","show-menu=downloads","downloads.htm","",1
,"Guides & Info","show-menu=guide","/basicintro.htm","",1
,"Account","show-menu=account","https://www.apphb.com/newaccount.htm","",1
,"Artwork","show-menu=artwork","/banners.htm","",1
,"Community","show-menu=community","/guilds.htm","",1
,"Customer Care","show-menu=customer","/contactus.htm","",1
,"Payment Help","show-menu=payment","/payment.htm","",1
,"FAQ","show-menu=faq","/faq.htm","",1

])

addmenu(menu=["about",,,151,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;Storyline","storyline.htm",,,1
,"&nbsp;Features","features.htm",,,1
,"&nbsp;Copyrights","copyrights.htm",,,1
,"&nbsp;Conduct Rules","rules.htm",,,1
,"&nbsp;FAQ","faq.htm",,,1
,"&nbsp;Game Reviews","GameReviews.htm",,,1
,"&nbsp;About iEN","http://www.ient.com/aboutus.htm target=_blank",,,1
,"&nbsp;iAffiliate","http://www.iamgame.com/affiliates/signup.htm target=_blank",,,1

])

addmenu(menu=["guide",,,150,1,,style1,0,"left",effect,,,,,,,,,,,,
,"&nbsp;Beginners &nbsp;Guide","basicintro.htm" ,,,1
,"&nbsp;Hotkeys","hotkeys.htm" ,,,1
,"&nbsp;Game Information","infoindex.htm",,,1
,"&nbsp;Crusade Overview","crusades.htm",,,1
,"&nbsp;Siege Overview","siege.htm",,,1
,"&nbsp;Maps","maps.htm",,,1
])

addmenu(menu=["account",,,150,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;CREATE A NEW ACCOUNT","https://secure.ient.com/hb/signup2.htm",,,1
,"&nbsp;Maintenance","https://secure.ient.com/am/",,,1
,"&nbsp;---------------------------","index.html",,,1

,"&nbsp;Name Change","charnamelogin.htm",,,1
,"&nbsp;Transfer Character","CharTransfer.htm",,,1
,"&nbsp;City Move","CharCityLogin.htm",,,1
,"&nbsp;Recruit a Crusader","https://secure.ient.com/hb/affiliate.htm",,,1
,"&nbsp;Armor Sex Change","ArmorChangeLogin.htm",,,1
,"&nbsp;Rep Check","CharRepRequest.htm",,,1
,"&nbsp;Spell Removal","CharSpellRemovalLogin.htm",,,1

,"&nbsp;Contribution Reduction","https://www.apphb.com/Cont-Reduction.htm",,,1

,"&nbsp;---------------------------","index.html",,,1
,"&nbsp;Disclaimer: Account Changes","toschanges.htm",,,1

])

addmenu(menu=["artwork",,,150,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;Wallpaper","wallpaper.htm",,,1
//,"&nbsp;Concept Art","art.htm",,,1
//,"&nbsp;Player Art","playerartwork.htm",,,1
,"&nbsp;Movies","movies.htm",,,1
,"&nbsp;Banners","banners.htm",,,1
])

addmenu(menu=["community",,,150,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;Forum","http://forums.hbportal.net/ target=_blank",,,1
,"&nbsp;Screenshots","playerpics_new.htm",,,1
,"&nbsp;Events","events.htm",,,1
,"&nbsp;- EK Exchange","eventsscavhunt004.htm",,,1
,"&nbsp;- Scavenger Hunts","events-tokenExchange-Scav.htm",,,1
,"&nbsp;- Portal Tokens","events-tokenExchange-PortalTokens.htm",,,1
,"&nbsp;- Mysterious Tokens","events-mysterious-tokens.htm",,,1
,"&nbsp;Quests","quest-list.htm",,,1
,"&nbsp;Contribution Rewards","https://www.apphb.com/events-quests-and-contribution.htm",,,1
,"&nbsp;Contribution Reduction","https://www.apphb.com/Cont-Reduction.htm",,,1
,"&nbsp;Voting Links","bonus-vote.htm",,,1
,"&nbsp;Guilds","guilds.htm",,,1
,"&nbsp;Top 50","topfifty.htm",,,1
,"&nbsp;Race To 180","RaceTo180.htm",,,1
,"&nbsp;Top EK's","topEKs.htm",,,1
,"&nbsp;Top CP's","topcontributors.htm",,,1
,"&nbsp;Published EK Lists","https://www.apphb.com/index.html?id=ek-links",,,1
,"&nbsp;Fan Sites","fansite.htm",,,1
])

addmenu(menu=["customer",,,150,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;Payment Methods","payment.htm",,,1
,"&nbsp;Bugs and Fixes","bugs.htm",,,1
,"&nbsp;Contact Form","contactAccounts.htm",,,1
,"&nbsp;Contact Us Details ","contactus.htm",,,1

,"&nbsp;Active GMs","activegms.htm",,,1
,"&nbsp;Need Help?","NeedHelp.htm",,,1
,"&nbsp;TIXX System","http://www.helsupport.com",,,1
,"&nbsp;Search the Site","search.htm",,,1
,"&nbsp;News Archives","archive.htm",,,1
])

addmenu(menu=["payment",,,150,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;Payment Methods","payment.htm",,,1
,"&nbsp;PayPal Overview","cash-shop-overview.htm",,,1
,"&nbsp;PayPal Subscriptions","cash-shop-paypal.htm",,,1
,"&nbsp;Pre-Pay Options","cash-shop-paypal-prepay.htm",,,1
,"&nbsp;Cash Shop","cash-shop.htm",,,1
,"&nbsp;Need Help?","NeedHelp.htm",,,1
])

addmenu(menu=["faq",,,150,1,"",style1,,"left",effect,,,,,,,,,,,,
,"&nbsp;Frequently Asked Questions","faq.htm",,,1
,"&nbsp;Experiencing Lag?","https://www.apphb.com/faq-lag.htm",,,1
,"&nbsp;---------------------------","index.html",,,1
,"&nbsp;Help: Stuck Char.","stuck.htm",,,1
,"&nbsp;Help: TIXX System.","http://www.helsupport.com",,,1
,"&nbsp;Help: Payment Methods","payment.htm",,,1
,"&nbsp;Help: PayPal Payment","giftvoucher.htm",,,1
])
dumpmenus()
