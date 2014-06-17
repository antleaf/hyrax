require 'spec_helper'

describe GenericWork do
  it "should have a title" do
    subject.title = 'foo'
    expect(subject.title).to eq 'foo'
  end

  context "with attached files" do
    subject { FactoryGirl.build(:work_with_files) }

    it "should have two files" do
      expect(subject.generic_files.size).to eq 2
      expect(subject.generic_files.first).to be_kind_of Worthwhile::GenericFile
    end
  end

  describe "to_solr" do
    subject { FactoryGirl.build(:work, date_uploaded: Date.today).to_solr }
    it "indexes some fields" do
      expect(subject.keys).to include 'desc_metadata__date_uploaded_dtsi'
    end
  end
end
