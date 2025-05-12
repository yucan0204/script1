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
    [994732206] = "Blox%20Fruits/Loader.lua",  -- 블록스 프루츠
    [1451439645] = "King%20Legacy/Loader.lua",
    [6765805766] = "Block%20Spin/Loader.lua",
    [7095682825] = "Beaks/Default.lua"
}

-- 인증 키 설정
local REQUIRED_KEY = "key"  -- 원하는 인증 키를 설정
local userKey = getgenv().AuthCode or ""

-- 인증 코드 확인
if userKey ~= REQUIRED_KEY then
    game.Players.LocalPlayer:Kick("❌ 인증 코드가 잘못되었습니다.")
    return
end

-- ✅ 인증 성공: UI 생성
local gui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "KeyAuthUI"

local label = Instance.new("TextLabel", gui)
label.Size = UDim2.new(0, 300, 0, 100)
label.Position = UDim2.new(0.5, -150, 0.5, -50)
label.Text = "✅ 인증 성공: 환영합니다!"
label.TextScaled = true
label.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
label.TextColor3 = Color3.fromRGB(255, 255, 255)

-- 인증 성공 후 3초 후 UI 제거 (선택사항)
task.delay(3, function()
    gui:Destroy()
end)

-- 스크립트 실행 (게임 ID에 맞는 로더 실행)
local scriptPath = GameList[GameId]
if scriptPath then
    loadstring(game:HttpGet(("https://raw.githubusercontent.com/yucan0204/script1/main/QuartyzScript-main/%s"):format(scriptPath)))()
end

-- 인증 서버 호출
request({
    ["Url"] = "https://auth.quartyz.com/execute?game=" .. GameId
        .. (getgenv().Mode and " " .. getgenv().Mode or "")
        .. "&executor=" .. executorname
        .. (getgenv().AuthCode and "&auth=" .. getgenv().AuthCode or "")
})
