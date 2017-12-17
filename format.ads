with ada.text_io;
with ada.finalization;

package format is
  ----------------------------------------------------------------------------
  -- basics

  type value is tagged limited private;
  type value_list is array (positive range <>) of value;

  function f(val: character) return value; -- TODO: prefix, suffix
  function f(val: string)    return value; -- TODO: prefix, suffix
  function f(val: integer)   return value; -- TODO: base, prefix, suffix
  function f(val: float)     return value; -- TODO: prefix, suffix, precision, notation

  ----------------------------------------------------------------------------
  -- extending formatter

  -- function for use in f()
  function make_value(val: string) return value;

  ----------------------------------------------------------------------------
  -- printing to STDOUT

  procedure print(fmt: string);
  procedure print(fmt: string; args: value_list);
  procedure println(fmt: string);
  procedure println(fmt: string; args: value_list);

  ----------------------------------------------------------------------------
  -- printing to a file

  procedure print(file: in out ada.text_io.file_type; fmt: string);
  procedure print(file: in out ada.text_io.file_type; fmt: string; args: value_list);
  procedure println(file: in out ada.text_io.file_type; fmt: string);
  procedure println(file: in out ada.text_io.file_type; fmt: string; args: value_list);

  ----------------------------------------------------------------------------
  -- printing to a string

  function format(fmt: string) return string;
  function format(fmt: string; args: value_list) return string;
  --procedure format(s: in out string; fmt: string);
  --procedure format(s: in out string; fmt: string; args: value_list);

  ----------------------------------------------------------------------------

private

  type string_ptr is access string;
  type value is new ada.finalization.limited_controlled with
    record
      str: string_ptr;
    end record;

  -- procedures inherited from ada.finalization.limited_controlled
  procedure initialize(f: in out value);
  procedure finalize(f: in out value);
end;
