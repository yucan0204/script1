repeat task.wait() until game:IsLoaded()

-- executor 감지
local executorname = "Unknown"
if getexecutorname then
    executorname = getexecutorname()
elseif identifyexecutor then
    executorname = identifyexecutor()
end

-- 블랙리스트된 executor 감지
local FAKE_EXECUTOR = { "xeno", "jjsploit" }
for i,v in pairs(FAKE_EXECUTOR) do
    if executorname:lower():find(v) then
        game.Players.LocalPlayer:Kick("\n\n" .. executorname .. " is not supported")
        return
    end
end

-- 게임 ID 인식
local GameId = game.GameId

-- 게임별 로더 경로
local GameList = {
    [5682590751] = "Lootify",
    [994732206] = "Blox%20Fruits/Loader.lua",
    [1451439645] = "King%20Legacy/Loader.lua",
    [6765805766] = "Block%20Spin/Loader.lua",
    [7095682825] = "Beaks/Default.lua"
}

-- 인증 키 설정
local REQUIRED_KEY = "key"  -- 원하는 인증 키

-- UI 생성
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "KeyAuthUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local textBox = Instance.new("TextBox", frame)
textBox.PlaceholderText = "인증 키를 입력하세요"
textBox.Size = UDim2.new(1, -20, 0, 40)
textBox.Position = UDim2.new(0, 10, 0, 10)
textBox.Text = ""
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextColor3 = Color3.fromRGB(0, 0, 0)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 60)
button.Text = "인증하기"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.fromRGB(255, 255, 255)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.new(0, 10, 1, -40)
status.Text = ""
status.TextScaled = true
status.BackgroundTransparency = 1
status.TextColor3 = Color3.fromRGB(255, 0, 0)

button.MouseButton1Click:Connect(function()
    local userKey = textBox.Text
    if userKey == REQUIRED_KEY then
        status.Text = "✅ 인증 성공!"
        status.TextColor3 = Color3.fromRGB(0, 255, 0)

        task.delay(1, function()
            gui:Destroy()

            -- 인증 성공 후 스크립트 로드
            local scriptPath = GameList[GameId]
            if scriptPath then
                loadstring(game:HttpGet(("https://raw.githubusercontent.com/yucan0204/script1/main/QuartyzScript-main/%s"):format(scriptPath)))()
            end

            -- 인증 서버 호출
            request({
                ["Url"] = "https://auth.quartyz.com/execute?game=" .. GameId
                    .. "&executor=" .. executorname
                    .. "&auth=" .. userKey
            })
        end)
    else
        status.Text = "❌ 인증 실패. 올바른 키를 입력하세요."
        status.TextColor3 = Color3.fromRGB(255, 0, 0)
    end
end)
