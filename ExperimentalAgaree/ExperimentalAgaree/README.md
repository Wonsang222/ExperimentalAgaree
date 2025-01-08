느낀점
1. 아키텍쳐를 고려하면 domain에서 에러에 대한 callback을 정해줘서 vm -> vc 로 전달해야하지 않았을까?
2. 프로토콜 상속을 조금 더 이용했어야했다.
3. 왜 RX, Combine이 사용되는지, 어떻게 사용해야하는지에 조금 더 알거같다.
4. 위 과정에서 불변성을 위해 Struct를 사용해야하는데... 
5. Testable 한 코드가 뭔지 조금은 알겠다. -> protocol로 mock dummy 등을 만들기 수월하게. 상속은 final 키워드와 함께 사용이 불가능해서 사용 지양
6. Network API Module화를 시도했다.
7. Memory Leak Instrument 사용
8. Generic 타입 공부를 했다. Associated Type을 공부하면서 Type Erasure를 만났고, Swift 버전이 바뀌며 Some, Opaque 까지.. 
