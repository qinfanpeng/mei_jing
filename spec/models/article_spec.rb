require 'spec_helper'

describe Article do
  subject{ build(:article) }

  it { should respond_to(:title) }
  it { should respond_to(:digest) }
  it { should respond_to(:status) }
  it { should respond_to(:publisher) }
  it { should respond_to(:content) }
  it { should respond_to(:columns) }

  it "is valid with title, digest, status, publisher, content" do
    expect(build(:article)).to be_valid
  end

  it "is invalid without title" do
    expect(build(:article, title: nil)).to have(1).errors_on(:title)
  end
  it "is invalid without content" do
    expect(build(:article, content: nil)).to have(1).errors_on(:content)
  end
  it "is invalid without publisher" do
    expect(build(:article, publisher: nil)).to have(1).errors_on(:publisher)
  end

  it "is invalid without digest" do
    expect(build(:article, digest: nil)).to have(1).errors_on(:digest)
  end
  it "is valid with digest less than 300 words" do
    expect(build(:article, digest: 'hello world' * 10)).to be_valid
  end
  it "is invalid with digest more than 300 words" do
    expect(build(:article, digest: 'hello world' * 100)).to have(1).errors_on(:digest)
  end


  it "is invalid without status" do
    expect(build(:article, status: nil)).to have(2).errors_on(:status)
  end
  it "is valid with status in  banned or published or drafted" do
    expect(build(:article, status: 'banned')).to be_valid
    expect(build(:article, status: 'published')).to be_valid
    expect(build(:article, status: 'drafted')).to be_valid
  end
  it "is valid with status out of banned or published or drafted" do
    expect(build(:article, status: 'tested')).to have(1).errors_on(:status)
  end

  it "its to_param is id-title" do
    article = build(:article)
    expect(article.to_param).to eq "#{article.id}-#{article.title}"
  end
end
