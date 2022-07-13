local client = Client(
    arg[2], 
    "skeltest"
)

local app = App(client)

assets = {
    quit = ui.Asset.File("images/quit.png"),
    box = ui.Asset.File("models/box.glb")
}
app.assetManager:add(assets)

local mainBounds = ui.Bounds(0, 1.2, -4,   1, 1, 1)
local box = ui.ModelView(mainBounds, assets.box)

app.mainView = box

local controls = ui.Surface(ui.Bounds(2, 1.2, -2,   1, 1.5, 0.01))
function makeControls(label, nodeName, y, delta)
    local controlledPose = ui.Pose(0,0,0)
    local button = controls:addSubview(ui.Button(ui.Bounds(0.0, y, 0.05,   0.2, 0.2, 0.1)))
    button.label:setText(label.."+")
    button.label.lineHeight = 0.05
    button.onActivated = function()
        controlledPose:move(unpack(delta))
        box:poseNode(nodeName, controlledPose)
    end
    button = controls:addSubview(ui.Button(ui.Bounds(-0.3, y, 0.05,   0.2, 0.2, 0.1)))
    button.label:setText(label.."-")
    button.label.lineHeight = 0.05
    button.onActivated = function()
        local x, y, z = unpack(delta)
        controlledPose:move(-x, -y, -z)
        box:poseNode(nodeName, controlledPose)
    end
    button = controls:addSubview(ui.Button(ui.Bounds(0.3, y, 0.05,   0.2, 0.2, 0.1)))
    button.label:setText(label.."R")
    button.label.lineHeight = 0.05
    button.onActivated = function()
        controlledPose:identity()
        box:resetNode(nodeName)
    end
end
makeControls("bott", "Bone.001", 0.6, {0.0, 0.3, 0})
makeControls("left", "Bone.002", 0.3, {0.3, 0.0, 0})
makeControls("right", "Bone.003", 0,   {0.3, 0.0, 0})
makeControls("top", "Bone.004", -0.3,{0.0, 0.3, 0})
makeControls("back", "Bone.005", -0.6,{0.0, 0.3, 0})

app:addRootView(controls)
app:connect()
app:run()
