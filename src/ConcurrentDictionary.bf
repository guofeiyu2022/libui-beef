using System;
using System.Collections;
using System.Threading;

namespace System.Collections.Concurrent
{
    public class ConcurrentDictionary<TKey, TValue> : Dictionary<TKey, TValue> where TKey : IHashable
    {
        // Monitor for thread synchronization
        private Monitor _monitor = new Monitor() ~ delete _;

        // Override Add method for thread safety
        public new void Add(TKey key, TValue value)
        {
            using (_monitor.Enter())
            {
                base.Add(key, value);
            }
        }

        // Override Remove method for thread safety
        public new bool Remove(TKey key)
        {
            using (_monitor.Enter())
            {
                return base.Remove(key);
            }
        }

        // Override indexer for thread safety
        public new TValue this[TKey key]
        {
            get
            {
                using (_monitor.Enter())
                {
                    return base[key];
                }
            }
            set
            {
                using (_monitor.Enter())
                {
                    base[key] = value;
                }
            }
        }

        // Override TryGetValue method for thread safety
        /*public new bool TryGetValue(TKey key, out TValue value)
        {
            _monitor.Enter();
            var ret = base.TryGetValue(key, out value);
            _monitor.Exit();
            return ret;
        }*/

        public new bool TryGetValue(TKey key, out TValue value)
        {
            using (_monitor.Enter())
            {
                return base.TryGetValue(key, out value);
            }
        }

        // Override ContainsKey method for thread safety
        public new bool ContainsKey(TKey key)
        {
            using (_monitor.Enter())
            {
                return base.ContainsKey(key);
            }
        }

        // Override Clear method for thread safety
        public new void Clear()
        {
            using (_monitor.Enter())
            {
                base.Clear();
            }
        }

        // Override Count property for thread safety
        public new int Count
        {
            get
            {
                using (_monitor.Enter())
                {
                    return base.Count;
                }
            }
        }
    }
}