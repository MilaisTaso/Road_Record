module ApplicationHelper
  #addressレコードのnameを結合し、表示する
  def get_address(addresses)
    total_address = []
    addresses.each do |address|
      total_address << address.name
    end
    address = total_address.join()
    return address
  end
  
  #フォームボタンのテキストを設定
  def get_submit_text
    path = request.path
    if path.include?("edit")
      "確定"
    else
      "投稿"
    end
  end
end
