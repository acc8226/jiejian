; 交换数组两元素
swap(arr, i, j) {
    temp := arr[i]
    arr[i] := arr[j]
    arr[j] := temp
}

; 冒泡排序，从大到小 属于稳定排序
dataArraySort(dataArray) {
    ; 对 listBoxData 进行冒泡排序
    i := 0
    while (i < dataArray.Length - 1) {
        flag := false
        j := 0
        while (j < dataArray.Length - 1 - i) {
            if (dataArrayCompare(dataArray[j + 1], dataArray[j + 2]) < 0) {
                swap(dataArray, j + 1, j + 2)
                flag := true
            }
            j++
        }
        if !flag
            break
        i++
    }
}

/**
 * 比较大小，如果第一个比较则返回负数，否则返回 0 相等 或者 1 表示第 2 个数较大
 * 
 * @param it1
 * @param it2
 * @returns {number}
 */
dataArrayCompare(it1, it2) {
    ; 排序按照 degree 降序、title 升序、type 升序
    result := it1.degree - it2.degree
    if (result == 0) {
        result := StrCompare(it2.title, it1.title)
        if result == 0        
            result := StrCompare(it2.type, it1.type)
    }
    return result
}

; 提取名称
listBoxData(dataArray) {
    retArray := Array()
    for it in dataArray {
        ; 根据 title 添加 “-类型” 的后缀
        retArray.push(it.title . "-" . it.type)
    }
    return retArray
}
