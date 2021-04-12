package com.example.tawasal.media;

public interface PackableEx extends Packable {
    void unmarshal(ByteBuf in);
}
