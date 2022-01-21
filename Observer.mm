#import "Observer.h"

#include "absl/synchronization/mutex.h"
#include <memory>
#include <mutex>
#include <atomic>
#include <map>
#include <string>
#include <vector>

class Store {
public:
  static std::shared_ptr<Store> SharedStore() {
    static std::shared_ptr<Store> shared_store = std::make_shared<Store>();
    return shared_store;

  }
  void Add(Observer *o) {
    observers_.push_back(o);
  }

  void Flush() {
//    for (Observer *o : observers_) {
//      {
//        [o storeDidUpdate];
//      }
//    }

    absl::MutexLock lock(&observer_mu_);
    for (Observer *o : observers_) {
      {
        observer_mu_.Unlock();
        [o storeDidUpdate];
        observer_mu_.Lock();
      }
    }
  }

  void Flush2() { // simulate ByteStore::NotifyObservers()
    std::vector<Observer *> observers;
    {
      absl::MutexLock lock(&observer_mu_);
      observers = observers_;
    }
    for (Observer *o : observers) {
        [o storeDidUpdate];
    }
    absl::MutexLock lock(&observer_mu_);
  }


private:
  mutable absl::Mutex observer_mu_;
  std::vector<Observer *> observers_;
};

@implementation Observer {
  NSNumber *_count;
}

- (instancetype)initWithCount:(NSNumber *)count {
  if (self = [super init]) {
    _count = count;
  }
  return self;
}

- (void)subscribe {
  Store::SharedStore()->Add(self);
}

- (void)storeDidUpdate {
  if ([_count intValue] == 8) {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:nil];
  }
  NSLog(@"updating count :%@", _count);
}

+ (void)flush {
  Store::SharedStore()->Flush2();
}

@end
