with ada.text_io;
with ada.finalization;

package format is
  ----------------------------------------------------------------------------
  -- format types

  type formatter is tagged limited private;
  type formatter_list is array (positive range <>) of formatter;

  function f(c: character) return formatter; -- TODO: prefix, suffix
  function f(s: string)    return formatter; -- TODO: prefix, suffix
  function f(i: integer)   return formatter; -- TODO: base, prefix, suffix
  function f(f: float)     return formatter; -- TODO: prefix, suffix, precision, notation

  ----------------------------------------------------------------------------
  -- printing to STDOUT

  procedure print(fmt: string);
  procedure print(fmt: string; args: formatter_list);
  procedure println(fmt: string);
  procedure println(fmt: string; args: formatter_list);

  ----------------------------------------------------------------------------
  -- printing to a file

  --procedure print(file: in out ada.text_io.file_type; fmt: string);
  --procedure print(file: in out ada.text_io.file_type; fmt: string; args: formatter_list);
  --procedure println(file: in out ada.text_io.file_type; fmt: string);
  --procedure println(file: in out ada.text_io.file_type; fmt: string; args: formatter_list);

  ----------------------------------------------------------------------------
  -- printing to a string

  function format(fmt: string) return string;
  function format(fmt: string; args: formatter_list) return string;
  --procedure format(s: in out string; fmt: string);
  --procedure format(s: in out string; fmt: string; args: formatter_list);

  ----------------------------------------------------------------------------

private

  type formatter is new ada.finalization.limited_controlled with
    record
      -- TODO: access string (formatted)
      -- TODO: access data'class (original value)
      null;
    end record;

  -- procedures inherited from ada.finalization.limited_controlled
  procedure initialize(f: in out formatter);
  procedure finalize(f: in out formatter);
end;
