module SW
  module OpenNewerVersion
    Sketchup.require File.join(PLUGIN_DIR, "open_newer_popen")

    # Add menu item at custom position in menu.
    #
    # The custom position is only used in SketchUp for Windows version 2016 and
    # above. In other versions the menu item will be placed at the end of the
    # menu. Please note that this is an undocumented SketchUp API behavior that
    # may be subject to change.
    #
    # @param menu [UI::Menu]
    # @param name [String]
    # @param position [Integer, nil]
    #
    # @example
    #   # Add Menu Item Right Below Entity Info
    #   UI.add_context_menu_handler do |menu|
    #     SkippyLib::LUI.add_menu_item(menu, "Entity Color Info", 1) do
    #       model = Sketchup.active_model
    #       entity = model.selection.first
    #       return unless entity
    #       color = entity.material ? entity.material.color : model.rendering_options["ForegroundColor"]
    #       UI.messagebox(color.to_a.join(", "))
    #     end
    #   end
    #
    # @return [Integer] identifier of menu item.
    def self.add_menu_item(menu, name, position = nil, &block)
      # Sketchup.platform added in SU2014.
      if position && Sketchup.platform == :platform_win && Sketchup.version.to_i >= 16
        menu.add_item(name, position, &block)
      else
        menu.add_item(name, &block)
      end
    end

    # Get index to place Open Newer Version at entry at.
    #
    # @return [Integer]
    def self.menu_index
      # Pre 2019:
      #   New
      #   Open...
      #   <-- Here
      #
      # 2019:
      #   New
      #   New From Template...
      #   Open...
      #   <-- Here
      Sketchup.version.to_i < 19 ?  2 : 3
    end

    # Menu
    unless @loaded
      @loaded = true

      menu = UI.menu("File")
      add_menu_item(menu, "Open Newer Version...", menu_index) do
        OpenNewer.open_newer_version
      end
    end
  end
end
