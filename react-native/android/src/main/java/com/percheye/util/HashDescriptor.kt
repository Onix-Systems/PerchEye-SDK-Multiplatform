package com.percheye.util

fun hashToDescriptor(hash: String): List<Short> {
  val chars = hash.toCharArray()

  return chars.map { it.code.toShort() }
}

fun descriptorToHash(descriptor: List<Short>): String {
  return descriptor.map { it.toInt().toChar() }.joinToString("")
}
