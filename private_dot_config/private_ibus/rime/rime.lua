-- Rime lua 扩展：https://github.com/hchunhui/librime-lua
-------------------------------------------------------------
-- 日期时间
-- 提高权重的原因：因为在方案中设置了大于 1 的 initial_quality，导致 rq sj xq dt ts 产出的候选项在所有词语的最后。
function date_translator(input, seg, env)
    local config = env.engine.schema.config
    local date = config:get_string(env.name_space .. "/date") or "rq"
    local time = config:get_string(env.name_space .. "/time") or "sj"
    local week = config:get_string(env.name_space .. "/week") or "xq"
    local datetime = config:get_string(env.name_space .. "/datetime") or "dt"
    local timestamp = config:get_string(env.name_space .. "/timestamp") or "ts"
    -- 日期
    if (input == date) then
        local cand = Candidate("date", seg.start, seg._end, os.date("%Y-%m-%d"), "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("date", seg.start, seg._end, os.date("%Y/%m/%d"), "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("date", seg.start, seg._end, os.date("%Y.%m.%d"), "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("date", seg.start, seg._end, os.date("%Y 年 %m 月 %d 日"), "")
        cand.quality = 100
        yield(cand)
    end
    -- 时间
    if (input == time) then
        local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M"), "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("time", seg.start, seg._end, os.date("%H:%M:%S"), "")
        cand.quality = 100
        yield(cand)
    end
    -- 星期
    if (input == week) then
        local weakTab = {'日', '一', '二', '三', '四', '五', '六'}
        local cand = Candidate("week", seg.start, seg._end, "星期" .. weakTab[tonumber(os.date("%w") + 1)], "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("week", seg.start, seg._end, "礼拜" .. weakTab[tonumber(os.date("%w") + 1)], "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("week", seg.start, seg._end, "周" .. weakTab[tonumber(os.date("%w") + 1)], "")
        cand.quality = 100
        yield(cand)
    end
    -- ISO 8601/RFC 3339 的时间格式 （固定东八区）（示例 2022-01-07T20:42:51+08:00）
    if (input == datetime) then
        local cand = Candidate("datetime", seg.start, seg._end, os.date("%Y-%m-%dT%H:%M:%S+08:00"), "")
        cand.quality = 100
        yield(cand)
        local cand = Candidate("time", seg.start, seg._end, os.date("%Y%m%d%H%M%S"), "")
        cand.quality = 100
        yield(cand)
    end
    -- 时间戳（十位数，到秒，示例 1650861664）
    if (input == timestamp) then
        local cand = Candidate("datetime", seg.start, seg._end, os.time(), "")
        cand.quality = 100
        yield(cand)
    end
end
-------------------------------------------------------------
-- 以词定字
-- https://github.com/BlindingDark/rime-lua-select-character
-- 删除了默认按键，需要在 key_binder（default.custom.yaml）下设置
-- 详见 `lua/select_character.lua`
-- select_character = require("select_character")
-------------------------------------------------------------
-- 长词优先（提升「西安」「提案」「图案」「饥饿」等词汇的优先级）
-- 感谢&参考于： https://github.com/tumuyan/rime-melt
-- 修改：不提升英文和中英混输的
function long_word_filter(input, env)
    -- 提升 count 个词语，插入到第 idx 个位置，默认 2、4。
    local config = env.engine.schema.config
    local count = config:get_int(env.name_space .. "/count") or 2
    local idx = config:get_int(env.name_space .. "/idx") or 4

    local l = {}
    local firstWordLength = 0 -- 记录第一个候选词的长度，提前的候选词至少要比第一个候选词长
    -- local s1 = 0 -- 记录筛选了多少个英语词条(只提升 count 个词的权重，并且对comment长度过长的候选进行过滤)
    local s2 = 0 -- 记录筛选了多少个汉语词条(只提升 count 个词的权重)

    local i = 1
    for cand in input:iter() do
        leng = utf8.len(cand.text)
        if (firstWordLength < 1 or i < idx) then
            i = i + 1
            firstWordLength = leng
            yield(cand)
		-- 不知道这两行是干嘛用的，似乎注释掉也没有影响。
		-- elseif #table > 30 then
		--     table.insert(l, cand)
		-- 注释掉了英文的
		-- elseif ((leng > firstWordLength) and (s1 < 2)) and (string.find(cand.text, "^[%w%p%s]+$")) then
		--     s1 = s1 + 1
		--     if (string.len(cand.text) / string.len(cand.comment) > 1.5) then
		--         yield(cand)
		--     end
		-- 换了个正则，否则中英混输的也会被提升
		-- elseif ((leng > firstWordLength) and (s2 < count)) and (string.find(cand.text, "^[%w%p%s]+$")==nil) then
        elseif ((leng > firstWordLength) and (s2 < count)) and (string.find(cand.text, "[%w%p%s]+") == nil) then
            yield(cand)
            s2 = s2 + 1
        else
            table.insert(l, cand)
        end
    end
    for i, cand in ipairs(l) do
        yield(cand)
    end
end
-------------------------------------------------------------
-- 降低部分英语单词在候选项的位置
-- https://dvel.me/posts/make-rime-en-better/#短单词置顶的问题
-- 感谢大佬 @[Shewer Lu](https://github.com/shewer) 指点
-------------------------------------------------------------
-- 参考于：https://github.com/rime/weasel/issues/733
function code_length_limit_processor(key, env)
    local ctx = env.engine.context
    local length_limit = 100
    if (length_limit ~= nil) then
        if (string.len(ctx.input) > length_limit) then
            -- ctx:clear()
            ctx:pop_input(1)
            return 1
        end
    end
    return 2
end
-------------------------------------------------------------
-- Unicode 输入
-- 复制自： https://github.com/shewer/librime-lua-script/blob/main/lua/component/unicode.lua
function unicode(input, seg, env)
    local ucodestr = seg:has_tag("unicode") and input:match("U(%x+)")
    if ucodestr and #ucodestr > 1 then
        local code = tonumber(ucodestr, 16)
        local text = utf8.char(code)
        yield(Candidate("unicode", seg.start, seg._end, text, string.format("U%x", code)))
        if #ucodestr < 5 then
            for i = 0, 15 do
                local text = utf8.char(code * 16 + i)
                yield(Candidate("unicode", seg.start, seg._end, text, string.format("U%x~%x", code, i)))
            end
        end
    end
end
-------------------------------------------------------------
