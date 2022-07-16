quat = require("modules.quat")

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
controls.grabbable = true
function makeControls(nodeName, y, delta, rot)
    local label = nodeName
    local controlledPose = ui.Pose(mat4.from_quaternion(quat(unpack(rot))))
    controlledPose:rotate(unpack(rot))
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
        controlledPose = ui.Pose(mat4.from_quaternion(quat(unpack(rot))))
        box:resetNode(nodeName)
    end
end

local n = 0.5773503
makeControls("top",    0.6, {0.0,  0.3, 0},   {0, 1, 0, 0})
makeControls("bottom", 0.3, {0.0, -0.3, 0},   {0, 0, -1, 0})
makeControls("left",   0.0, {-0.3, 0.0, 0},   {-0.5, 0.5, 0.5, 0.5})
makeControls("right", -0.3, {0.3,  0.0, 0},   {-0.5, -0.5, -0.5, 0.5})
makeControls("front", -0.6, {0.0,  0,  -0.3}, {-0.7, 0, 0, 0.7})
makeControls("back",  -0.9, {0.0,  0,   0.3}, {0, 0.7, 0.7, 0})

app:addRootView(controls)
app:connect()
app:run()
