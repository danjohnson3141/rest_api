require 'spec_helper'

describe 'Events' do  

  # Valid Conditions
  # ====================================================================================================================
  it 'Name Validation; valid when name not blank and unique' do
    create(:event, :random, name: '2013 Test Event', begin_date: '2013-03-04', end_date: '2013-03-06')
    create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-04', end_date: '2014-03-06')
    Event.count.should eq 2
  end

  it 'Date Validation; valid when begin date < end date' do
    create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-04', end_date: '2014-03-06')
    Event.count.should eq 1
  end

  it 'Date Validation; valid when begin date <= end date' do
    create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-06', end_date: '2014-03-06')
    Event.count.should eq 1
  end

  # Invalid Conditions
  # ====================================================================================================================
  it 'Name Validation; invalid when name blank' do
    begin
      create(:event, :random, name: '', begin_date: '2014-03-04', end_date: '2014-03-06')
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordInvalid
    end
    Event.count.should eq 0
  end

  it 'Name Validation; invalid when name not unique' do
    create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-04', end_date: '2014-03-06')
    begin
      create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-04', end_date: '2014-03-06')
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordInvalid
    end
    Event.count.should eq 1
  end

  it 'Date Validation; invalid when begin date not <= end date' do
    begin
      create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-06', end_date: '2014-03-04')
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordInvalid
    end
    Event.count.should eq 0
  end

  it 'Date Validation; invalid when begin date is blank' do
    begin
      create(:event, :random, name: '2014 Test Event', begin_date: nil, end_date: '2014-03-04')
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordInvalid
    end
    Event.count.should eq 0
  end

  it 'Date Validation; invalid when end date is blank' do
    begin
      create(:event, :random, name: '2014 Test Event', begin_date: '2014-03-06', end_date: nil)
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordInvalid
    end
    Event.count.should eq 0
  end

end