module ApplicationHelper

  # 将时间显示为如下格式
  # 2012.9.5 下午 4:20
  def beautify_time(time)
    time.strftime("%Y.%-m.%-d %p %k:%M").gsub('PM', "下午").gsub('AM', "上午")
  end

  def short_time(time)
    time.strftime("%Y.%-m.%-d")
  end
  
end
