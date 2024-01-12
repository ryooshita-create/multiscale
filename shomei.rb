# coding: utf-8
require 'date'
require 'csv'

class CLAProgram
  attr_accessor :signatures

  def initialize
    @signatures = []
    load_from_file("cla_signatures.csv") # プログラム開始時に既存の署名履歴を読み込む
  end

  def add_signature(name)
    signature = {
      name: name,
      signed_at: DateTime.now
    }
    @signatures << signature
    puts "#{name} さん、CLAに署名しました。"
  end

  def display_signatures
    if @signatures.empty?
      puts "まだ誰も署名していません。"
    else
      puts "署名履歴:"
      @signatures.each do |signature|
        puts "#{signature[:name]} - #{signature[:signed_at]}"
      end
    end
  end

  def save_to_file(file_path)
    CSV.open(file_path, 'a+') do |csv|
      # ファイルが空の場合はヘッダ行を追加
      csv << ['名前', '署名日時'] if csv.count.eql?(0)
      @signatures.each do |signature|
        csv << [signature[:name], signature[:signed_at]]
      end
    end
    puts "署名履歴を #{file_path} に保存しました。"
  end

  def load_from_file(file_path)
    return unless File.exist?(file_path)

    CSV.foreach(file_path, headers: true) do |row|
      @signatures << { name: row['名前'], signed_at: DateTime.parse(row['署名日時']) }
    end
  end
end

cla_program = CLAProgram.new

# ユーザーに署名者の名前を入力してもらう
print "あなたの名前を入力してください: "
user_name = gets.chomp

# 入力された名前で署名を追加
cla_program.add_signature(user_name)

# 署名履歴を表示
cla_program.display_signatures

# ファイルに署名履歴を保存
cla_program.save_to_file("cla_signatures.csv")
