function CreatePosterScreen(contentList, breadcrumb = "Jupiter Broadcasting")
	instance = CreateObject("roAssociativeArray")

	instance.screen = CreateObject("roPosterScreen")
	instance.messagePort = CreateObject("roMessagePort")
	instance.screen.SetMessagePort(instance.messagePort)

	instance.screen.setListStyle("flat-category")
	instance.screen.setBreadcrumbText("", breadcrumb)
	instance.contentList = contentList
	
	instance.showScreen = function()
		m.showAds()
		m.setContentList(m.contentList)
		m.showPoster()
		m.waitForInput()
	end function
	
	instance.setStyle = function(style)
		m.screen.setListStyle(style)
	end function
	
	instance.setBreadcrumb = function(a, b)
		instance.screen.setBreadcrumbText(a, b)
	end function
	
	instance.setContentList = function(contentList)
		m.screen.setContentList(contentList)
	end function

	instance.showAds = function()
		'Don't show ads, really
		'm.screen.setAdURL(sdAd, hdAd)
		'm.screen.setAdSelectable(false)
		x = 0 'Don't break the editor
	end function
	
	instance.showPoster = function()
		m.screen.Show()
	end function
	
	instance.waitForInput = function()
		while true
			msg = wait(0, m.messagePort)
			if msg <> invalid
				if msg.isScreenClosed()
					exit while
				else if msg.isListItemSelected()
					selectedItem = m.contentList[msg.Getindex()]
					if selectedItem.screenTarget = "video"
						CreateVideoScreen(selectedItem).showScreen()
					else if selectedItem.screenTarget = "livestream"
						CreateLivestreamScreen(selectedItem).showScreen()
					else if selectedItem.screenTarget = "quality"
						ShowQualityDialog()
						m.contentList = LoadConfig()
						m.SetContentList(m.contentList)
						m.showPoster()
					else if selectedItem.screenTarget = "paragraph"
						ShowParagraphScreen(selectedItem)
					else if selectedItem.categories <> invalid and selectedItem.categories.Count() > 0
						CreatePosterScreen(selectedItem.categories, selectedItem.shortDescriptionLine1).showScreen()
					else
						ShowEpisodeScreen(selectedItem, selectedItem.shortDescriptionLine1)
					end if
				end if
			end if
		end while
	end function

	return instance
end function
