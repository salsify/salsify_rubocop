# frozen_string_literal: true

describe RuboCop::Cop::Salsify::DelayedJobSelfEnqueue, :config do
  subject(:cop) { described_class.new(config) }

  it "registers an offense when enqueuing self" do
    expect_offense(<<~RUBY)
      Delayed::Job.enqueue(self, run_at: 5.minutes.from_now)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not pass `self` to `Delayed::Job.enqueue`. Create a new job instance to avoid serializing memoized AR objects.
    RUBY
  end

  it "registers an offense when enqueuing self without options" do
    expect_offense(<<~RUBY)
      Delayed::Job.enqueue(self)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not pass `self` to `Delayed::Job.enqueue`. Create a new job instance to avoid serializing memoized AR objects.
    RUBY
  end

  it "registers an offense with fully qualified constant" do
    expect_offense(<<~RUBY)
      ::Delayed::Job.enqueue(self, run_at: run_at)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Do not pass `self` to `Delayed::Job.enqueue`. Create a new job instance to avoid serializing memoized AR objects.
    RUBY
  end

  it "does not register an offense when enqueuing a new instance" do
    expect_no_offenses(<<~RUBY)
      new_job = self.class.new(publication_id: publication_id)
      Delayed::Job.enqueue(new_job, run_at: 5.minutes.from_now)
    RUBY
  end

  it "does not register an offense when enqueuing self.class.new" do
    expect_no_offenses(<<~RUBY)
      Delayed::Job.enqueue(self.class.new(foo: foo), run_at: run_at)
    RUBY
  end

  it "does not register an offense for other Delayed::Job methods" do
    expect_no_offenses(<<~RUBY)
      Delayed::Job.delete_all
    RUBY
  end

  it "does not register an offense when self is passed as a string or symbol" do
    expect_no_offenses(<<~RUBY)
      Delayed::Job.enqueue(:self)
    RUBY
  end
end
