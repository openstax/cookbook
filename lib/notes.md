```ruby
def first_of
  FirstOfEnumerator(book.units.chapters, book.chapters, book).pages.each do |page|

  end
end
```

When baking moves an important element (e.g. something with a data-type that we latch onto), it should update how to find that element in the future by changing the selector on the doc.
