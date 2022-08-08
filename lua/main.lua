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

local controls = ui.Surface(ui.Bounds(2, 1.2, -2,   1, 2.00, 0.01))
controls.grabbable = true

local label = controls:addSubview(ui.Label(ui.Bounds(0, 0.9, 0,    0.7, 0.10, 0.01)))
label.wrap = true
label:setText("box.glb (built-in)")
label:setColor({0,0,0,1})

controls.acceptedFileExtensions = {"glb"}
controls.onFileDropped = function(view, filename, asset_id)
    app.assetManager:load(asset_id, function (name, asset)
        if asset then
            label:setText(filename)
            box:setAsset(asset)
        else
            local error = "Failed to load "..filename
            print(error)
            label:setText(error)
        end
    end)
end

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
