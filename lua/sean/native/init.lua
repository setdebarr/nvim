local utils = require("sean.utils")

if utils.theme == "caelus" then
    require("sean.themes.caelus").colorscheme()
end

require("sean.native.bitbake").setup()
require("sean.native.lang")
