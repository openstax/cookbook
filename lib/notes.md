Can we get

```ruby
book.pages.terms.each do |term|
  term.number_in(:page)
  term.page
  term.number_in(:book)
  term.book
end
```

https://medium.com/@baweaver/exploring-ruby-2-6-proc-compose-and-enumerator-chain-49f10e237542


Maybe all the iterator methods go into the Enumerator classes


e.g.

class PageElementEnumerator
  def terms
    TermElementEnumerator.new....
    ...
    # pass in counts from here and up
  end
end

so you can say `my_book.pages.terms`

class PageElement
  def terms
    PageElementEnumerator.new([self], :each).terms
  end
end

so you can say `my_page.terms`
