module ApplicationHelper

  # 将时间显示为如下格式
  # 2012.9.5 下午 4:20
  def beautify_time(time)
    time.localtime.strftime("%Y.%-m.%-d %p %l:%M").gsub('PM', "下午").gsub('AM', "上午")
  end

  def short_time(time)
    time.localtime.strftime("%Y.%-m.%-d")
  end

  def beautify_time_with_br(time)
    time.localtime.strftime("%Y.%-m.%-d <br> %l:%M %p").gsub('PM', "下午").gsub('AM', "上午").html_safe
  end

  def link_to_add_fields(f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to('#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")}) do
      raw "<i class=\"icon-plus-sign\"></i>"
    end
  end
end
