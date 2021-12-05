# frozen_string_literal: true

# wraps some code of Tk to make it more object oriented, provide new
# functionality and to ease usage
module TkWrapper
  module Widget
    def configure(tkwidget, configuration)
      configure_grid(tkwidget, configuration['grid'])
    end

    def configure_grid(tkwidget, configuration)
      return unless configuration

      if configuration.is_a?(TrueClass)
        TkGrid.columnconfigure(tkwidget, 0, weight: 1)
        TkGrid.rowconfigure(tkwidget, 0, weight: 1)
      else
        tkwidget.grid(**configuration)
      end
    end
  end
end
