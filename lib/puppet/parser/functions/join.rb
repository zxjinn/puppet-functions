#
# join.rb
#
# Copyright 2012 Krzysztof Wilczynski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

module Puppet::Parser::Functions
  newfunction(:join, :type => :rvalue, :doc => <<-EOS
Returns a new string which is the concatenation of each element of the array
into a string using separator given.

Prototype:

    join(a)
    join(a, s)

Where a is an array and s is the separator to join array elements with.

For example:

  Given the following statements:

    $a = ['a', 'b', 'c']
    $b = ','

    notice join($a)
    notice join($a, $b)

  The result will be as follows:

    notice: Scope(Class[main]): abc
    notice: Scope(Class[main]): a,b,c
    EOS
  ) do |*arguments|
    #
    # This is to ensure that whenever we call this function from within
    # the Puppet manifest or alternatively form a template it will always
    # do the right thing ...
    #
    arguments = arguments.shift if arguments.first.is_a?(Array)

    # Technically we support two arguments but only first is mandatory ...
    raise Puppet::ParseError, "join(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)" if arguments.size < 1

    array = arguments.shift

    raise Puppet::ParseError, 'join(): Requires an array type ' +
      'to work with' unless array.is_a?(Array)

    separator = arguments.shift unless arguments.empty?

    if separator and not separator.is_a?(String)
      raise Puppet::ParseError, 'join(): Requires separator to be of a string type'
    end

    # We join with separator or just join ...
    separator ? array.join(separator) : array.join
  end
end

# vim: set ts=2 sw=2 et :
# encoding: utf-8
