require File.expand_path("../../../test_helper", __FILE__)

describe "rebuilding" do
  before :each do
    DatabaseCleaner.clean
  end

  describe "rebuild" do
    it "should rebuild position for all records" do
      item1 = Item.create(position: binpos("00111"))
      item2 = Item.create(position: binpos("101101"))
      item3 = Item.create(position: binpos("11101"))
      Item.list.balance!
      assert_equal %w[01 1 11].map { |b| binpos(b) }, Item.ordered.map(&:position)
    end

    it "should shift position forward for all records" do
      item1 = Item.create(position: binpos("001"))
      item2 = Item.create(position: binpos("01"))
      item3 = Item.create(position: binpos("1"))
      Item.list.balance!
      assert_equal %w[01 1 11].map { |b| binpos(b) }, Item.ordered.map(&:position)
    end

    it "should shift position backward for all records" do
      item1 = Item.create(position: binpos("1"))
      item2 = Item.create(position: binpos("11"))
      item3 = Item.create(position: binpos("111"))
      Item.list.balance!
      assert_equal %w[01 1 11].map { |b| binpos(b) }, Item.ordered.map(&:position)
    end

    it "should adjust position length according to number of records" do
      16.times { Item.create }
      Item.list.balance!
      assert_equal 4, Item.ordered.first.position.length
    end

    it "should keep many records in order" do
      n = 16
      n.times { |i| Item.create(name: i) }
      Item.list.balance!
      assert_equal n.times.map(&:to_s), Item.ordered.map(&:name)
    end

    # it "should rebuild positions so duplicates cannot occur" do
    #   item1 = Item.create(position: binpos("01"))
    #   item2 = Item.create(position: binpos("1"))
    #   item3 = Item.create(position: binpos("11"))
    #   Item.list.balance!
    #   assert_raises ActiveRecord::RecordNotUnique do
    #     Item.create(position: binpos("1"))
    #   end
    # end
  end

  # it "bench" do
  #   n = 10
  #   20.times { Item.create }
  #   p Item.connection.select_all Item.list.reversed.send(:b).to_sql
  #   p Item.connection.select_all Item.list.reversed.send(:a).to_sql
  #   exit
  #   require "benchmark"
  #   Benchmark.bm do |bm|
  #     bm.report "stupid" do
  #       n.times {
  #         Item.list.send(:b).to_a
  #       }
  #     end
  #     bm.report "pg" do
  #       n.times {
  #         Item.list.send(:a).to_a
  #       }
  #     end
  #   end
  # end
end
