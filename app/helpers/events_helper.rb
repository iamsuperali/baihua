#coding: utf-8
module EventsHelper
  #   RULE_LIST = [
  #     ["返校迟到",1],
  #     ["病假",2],
  #     ["事假",3],
  #     ["病假离校",4],
  #     ["事假离校",5],
  #     ["没穿校服",6],
  #     ["发型不符合要求",7],
  #     ["指甲不符合要求",8],
  #     ["带一次性饭盒",9]
  #   ]

  def format_rule_type(rule_type)
    (Event::RULE_LIST.find{|s| s[1] == rule_type})[0]
  end

  def format_rule_cate(rule_cate)
    Event.format_rule_cate(rule_cate)
  end

  def cate_list(cur_params="")
    options = ""
    Event::CATE_LIST.each do |c|
      options += "<option value='#{c[1]}' #{c[1] == cur_params ? "selected='selected'" : ""}>#{c[0]}</option>"
    end
    return options.html_safe
  end
end
