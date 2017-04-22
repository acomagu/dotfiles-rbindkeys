# -*- coding:utf-8; mode:ruby; -*-

require 'thread'
require 'socket'

pre_bind_key KEY_CAPSLOCK, KEY_LEFTCTRL
pre_bind_key KEY_RO, KEY_RIGHTSHIFT
bind_key [KEY_LEFTCTRL, KEY_J], KEY_BACKSPACE
bind_key [KEY_LEFTCTRL, KEY_C], [KEY_LEFTCTRL, KEY_C] # For vim

def dvorak_to_qwerty keys
  def convert_key key
    table = {
      KEY_A => KEY_A,
      KEY_B => KEY_X,
      KEY_C => KEY_J,
      KEY_D => KEY_E,
      KEY_E => KEY_DOT,
      KEY_F => KEY_U,
      KEY_G => KEY_I,
      KEY_H => KEY_D,
      KEY_I => KEY_C,
      KEY_J => KEY_H,
      KEY_K => KEY_T,
      KEY_L => KEY_N,
      KEY_M => KEY_M,
      KEY_N => KEY_B,
      KEY_O => KEY_R,
      KEY_P => KEY_L,
      KEY_Q => KEY_APOSTROPHE,
      KEY_R => KEY_P,
      KEY_S => KEY_O,
      KEY_T => KEY_Y,
      KEY_U => KEY_G,
      KEY_V => KEY_K,
      KEY_W => KEY_COMMA,
      KEY_X => KEY_Q,
      KEY_Y => KEY_F,
      KEY_Z => KEY_SEMICOLON,
      KEY_DOT => KEY_V,
      KEY_COMMA => KEY_W,
      KEY_SEMICOLON => KEY_S,
      KEY_SLASH => KEY_Z,
      KEY_APOSTROPHE => KEY_MINUS
    }
    table.invert()[key]
  end

  (keys.instance_of? Array) ? keys.map{|k| convert_key(k)} : convert_key(keys)
end

def push_key key
  operator.press_key key
  operator.pressing_key key
  operator.release_key key if using_ime?
end

def push_keys keys
  if keys.instance_of? Array then
    keys.each do |key|
      push_key key
    end
  else
    push_key keys
  end
end

def using_ime?
  status = false;
  UNIXSocket.open('/tmp/fcitx-socket-:0') do |sock|
    sock.write [0].pack('i!')
    status = sock.readline.chomp.unpack('i!')[0] == 2
  end
  status
end

def bind_ime_with_thumb tkey, lkey, rkey
  bind_ime [tkey, lkey], rkey
  bind_ime [lkey, tkey], rkey do |event, operator|
    operator.press_key KEY_BACKSPACE
    operator.release_key KEY_BACKSPACE
  end
end

def bind_ime lval, rval
  rval = dvorak_to_qwerty(rval)
  bind_key lval do |event, operator|
    yield event, operator if block_given?
    push_keys (using_ime? ? rval : lval)
  end
end

bind_ime KEY_MUHENKAN, []
bind_ime KEY_HENKAN, []

bind_key [KEY_KATAKANAHIRAGANA, KEY_V], KEY_UP
bind_key [KEY_KATAKANAHIRAGANA, KEY_P], KEY_RIGHT
bind_key [KEY_KATAKANAHIRAGANA, KEY_C], KEY_DOWN
bind_key [KEY_KATAKANAHIRAGANA, KEY_J], KEY_LEFT
bind_key [KEY_KATAKANAHIRAGANA, KEY_R], KEY_UP
bind_key [KEY_KATAKANAHIRAGANA, KEY_Y], KEY_RIGHT
bind_key [KEY_KATAKANAHIRAGANA, KEY_L], KEY_DOWN
bind_key [KEY_KATAKANAHIRAGANA, KEY_N], KEY_LEFT

bind_key [KEY_KATAKANAHIRAGANA, KEY_H], KEY_PAGEDOWN
bind_key [KEY_KATAKANAHIRAGANA, KEY_F], KEY_PAGEUP

bind_key [KEY_KATAKANAHIRAGANA, KEY_COMMA], [KEY_LEFTALT, KEY_F4]

# Single Key Input
bind_ime KEY_A, KEY_U
bind_ime KEY_B, [KEY_H, KEY_E]
bind_ime KEY_C, [KEY_S, KEY_U]
bind_ime KEY_D, [KEY_T, KEY_E]
bind_ime KEY_E, [KEY_T, KEY_A]
bind_ime KEY_F, [KEY_K, KEY_E]
bind_ime KEY_G, [KEY_S, KEY_E]
bind_ime KEY_H, [KEY_H, KEY_A]
bind_ime KEY_I, [KEY_K, KEY_U]
bind_ime KEY_J, [KEY_T, KEY_O]
bind_ime KEY_K, [KEY_K, KEY_I]
bind_ime KEY_L, KEY_I
bind_ime KEY_M, [KEY_S, KEY_O]
bind_ime KEY_N, [KEY_M, KEY_E]
bind_ime KEY_O, [KEY_T, KEY_S, KEY_U]
bind_ime KEY_P, KEY_COMMA
bind_ime KEY_Q, KEY_DOT
bind_ime KEY_R, [KEY_K, KEY_O]
bind_ime KEY_S, [KEY_S, KEY_H, KEY_I]
bind_ime KEY_T, [KEY_S, KEY_A]
bind_ime KEY_U, [KEY_C, KEY_H, KEY_I]
bind_ime KEY_V, [KEY_F, KEY_U]
bind_ime KEY_W, [KEY_K, KEY_A]
bind_ime KEY_X, [KEY_H, KEY_I]
bind_ime KEY_Y, [KEY_R, KEY_A]
bind_ime KEY_Z, KEY_DOT
bind_ime KEY_COMMA, [KEY_N, KEY_E]
bind_ime KEY_DOT, [KEY_H, KEY_O]
bind_ime KEY_SEMICOLON, [KEY_N, KEY_N]
bind_ime KEY_LEFTBRACE, [KEY_COMMA]

# Shift Input
bind_ime_with_thumb KEY_MUHENKAN, KEY_A, [KEY_W, KEY_O]
bind_ime_with_thumb KEY_MUHENKAN, KEY_B, [KEY_L, KEY_I]
bind_ime_with_thumb KEY_MUHENKAN, KEY_C, [KEY_R, KEY_O]
bind_ime_with_thumb KEY_MUHENKAN, KEY_D, [KEY_N, KEY_A]
bind_ime_with_thumb KEY_MUHENKAN, KEY_E, [KEY_R, KEY_I]
bind_ime_with_thumb KEY_MUHENKAN, KEY_F, [KEY_L, KEY_Y, KEY_U]
bind_ime_with_thumb KEY_MUHENKAN, KEY_G, [KEY_M, KEY_O]
bind_ime_with_thumb KEY_MUHENKAN, KEY_Q, [KEY_L, KEY_A]
bind_ime_with_thumb KEY_MUHENKAN, KEY_R, [KEY_L, KEY_Y, KEY_A]
bind_ime_with_thumb KEY_MUHENKAN, KEY_S, KEY_A
bind_ime_with_thumb KEY_MUHENKAN, KEY_T, [KEY_R, KEY_E]
bind_ime_with_thumb KEY_MUHENKAN, KEY_V, [KEY_Y, KEY_A]
bind_ime_with_thumb KEY_MUHENKAN, KEY_W, KEY_E
bind_ime_with_thumb KEY_MUHENKAN, KEY_X, KEY_MINUS
bind_ime_with_thumb KEY_MUHENKAN, KEY_Z, [KEY_L, KEY_U]

bind_ime_with_thumb KEY_HENKAN, KEY_H, [KEY_M, KEY_I]
bind_ime_with_thumb KEY_HENKAN, KEY_I, [KEY_R, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_J, KEY_O
bind_ime_with_thumb KEY_HENKAN, KEY_K, [KEY_N, KEY_O]
bind_ime_with_thumb KEY_HENKAN, KEY_L, [KEY_L, KEY_Y, KEY_O]
bind_ime_with_thumb KEY_HENKAN, KEY_M, [KEY_Y, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_N, [KEY_N, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_O, [KEY_M, KEY_A]
bind_ime_with_thumb KEY_HENKAN, KEY_P, [KEY_L, KEY_E]
bind_ime_with_thumb KEY_HENKAN, KEY_U, [KEY_N, KEY_I]
bind_ime_with_thumb KEY_HENKAN, KEY_Y, [KEY_Y, KEY_O]
bind_ime_with_thumb KEY_HENKAN, KEY_COMMA, [KEY_M, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_DOT, [KEY_W, KEY_A]
bind_ime_with_thumb KEY_HENKAN, KEY_SEMICOLON, [KEY_X, KEY_T, KEY_S, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_SLASH, [KEY_X, KEY_O]

# Cross Shift Input
bind_ime_with_thumb KEY_HENKAN, KEY_A, [KEY_V, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_B, [KEY_B, KEY_E]
bind_ime_with_thumb KEY_HENKAN, KEY_C, [KEY_Z, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_D, [KEY_D, KEY_E]
bind_ime_with_thumb KEY_HENKAN, KEY_E, [KEY_D, KEY_A]
bind_ime_with_thumb KEY_HENKAN, KEY_F, [KEY_G, KEY_E]
bind_ime_with_thumb KEY_HENKAN, KEY_G, [KEY_Z, KEY_E]
bind_ime_with_thumb KEY_HENKAN, KEY_R, [KEY_G, KEY_O]
bind_ime_with_thumb KEY_HENKAN, KEY_S, [KEY_Z, KEY_I]
bind_ime_with_thumb KEY_HENKAN, KEY_T, [KEY_Z, KEY_A]
bind_ime_with_thumb KEY_HENKAN, KEY_V, [KEY_B, KEY_U]
bind_ime_with_thumb KEY_HENKAN, KEY_W, [KEY_G, KEY_A]
bind_ime_with_thumb KEY_HENKAN, KEY_X, [KEY_B, KEY_I]

bind_ime_with_thumb KEY_MUHENKAN, KEY_H, [KEY_B, KEY_A]
bind_ime_with_thumb KEY_MUHENKAN, KEY_I, [KEY_G, KEY_U]
bind_ime_with_thumb KEY_MUHENKAN, KEY_J, [KEY_D, KEY_O]
bind_ime_with_thumb KEY_MUHENKAN, KEY_K, [KEY_G, KEY_I]
bind_ime_with_thumb KEY_MUHENKAN, KEY_L, [KEY_P, KEY_O]
bind_ime_with_thumb KEY_MUHENKAN, KEY_M, [KEY_Z, KEY_O]
bind_ime_with_thumb KEY_MUHENKAN, KEY_N, [KEY_P, KEY_U]
bind_ime_with_thumb KEY_MUHENKAN, KEY_O, [KEY_D, KEY_U]
bind_ime_with_thumb KEY_MUHENKAN, KEY_P, [KEY_P, KEY_I]
bind_ime_with_thumb KEY_MUHENKAN, KEY_U, [KEY_D, KEY_I]
bind_ime_with_thumb KEY_MUHENKAN, KEY_Y, [KEY_P, KEY_A]
bind_ime_with_thumb KEY_MUHENKAN, KEY_COMMA, [KEY_P, KEY_E]
bind_ime_with_thumb KEY_MUHENKAN, KEY_DOT, [KEY_B, KEY_O]
