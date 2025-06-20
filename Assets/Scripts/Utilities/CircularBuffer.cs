using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CircularBuffer<T>
{
    private T[] _buffer;
    private int _start;
    private int _end;
    private int _count;
    private int _size;

    public CircularBuffer(int size)
    {
        _buffer = new T[size];
        _size = size;
        _start = 0;
        _end = 0;
        _count = 0;
    }

    public void Add(T item)
    {
        _buffer[_end] = item;
        _end = (_end + 1) % _size;
        if (_count == _size)
        {
            _start = (_start + 1) % _size; // Overwrite the oldest item
        }
        else
        {
            _count++;
        }
    }

    public T Get(int index)
    {
        if (index < 0 || index >= _count)
        {
            throw new IndexOutOfRangeException();
        }
        return _buffer[(_start + index) % _size];
    }

    public int GetIndexByValue(T value)
    {
        for (int i = 0; i < _count; i++)
        {
            int actualIndex = (_start + i) % _size;
            if (_buffer[actualIndex].Equals(value))
            {
                return i;
            }
        }
        return -1; // Value not found
    }

    public int Count
    {
        get { return _count; }
    }
}
